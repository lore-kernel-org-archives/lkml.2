Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1BJXOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:14:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:58912 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819Ab1BJXOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:14:48 -0500
Message-ID: <4D54715C.6060909@suse.cz>
Date: Fri, 11 Feb 2011 00:14:36 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ulf Magnusson <ulfalizer.lkml@gmail.com>
Cc: linux-kbuild@vger.kernel.org, rdunlap@xenotime.net,
        akpm@linux-foundation.org, andrea.gelmini@gelma.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python Kconfig
 parser
References: <20110201232750.GA30800@ulf>
In-Reply-To: <20110201232750.GA30800@ulf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.2.2011 00:27, Ulf Magnusson wrote:
> Hi,
> 
> This is the initial release of Kconfiglib: a Python library for
> scripting, debugging, and extracting information from Kconfig-based
> configuration systems.  It can be used to programmatically generate a
> .config when the '*conf' tools are too inflexible, to quickly find out
> interesting information about a Kconfig configuration such as dependency
> relations between symbols and where undefined symbols are referenced,
> and in applications that need to parse and extract information from
> Kconfig files.
> 
> For a much longer introduction including multiple examples, see
> arch/kconfig/kconfiglib.py.

Hi,

this looks like a very powerful tool, but I have a similar concern like
Arnaud had - being completely standalone, it reimplements most of the C
kconfig code. One option to reduce this duplication would be a swig
wrapper, another one would be to let the C code parse the Kconfig files
and write the required information in some digested form, that would be
easier to parse by scripts. Something like:
$ scripts/kconfig/conf_inspect --kconfig=Kconfig --eval='FOO || BAR'
y
$ scripts/kconfig/conf_inspect ... --dump-symbols
config FOO
type: bool
valule: m
visible: y
prompt: "zzz"
depends: X & Y
select: Z
...
$ scripts/kconfig/conf_inspect ... --dump-symbols \
    --fields='depends,select,value'
config FOO
depends: X & Y
select: Z
value: m

config BAR
...

etc. The idea is that for instance instead of parsing the Kconfig files,
the Python code could fill it's data structures by reading the flat dump
provided by the C kconfig. There would be still lot to do in Python,
e.g. parsing and evaluating expressions, but it would be a small step
forward already. And people wanting to write quick&dirty scripts in
bash/awk/perl would make use of the C code as well.

Michal
