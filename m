Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2C3F0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 01:26:18 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:21991 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2C3F0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 01:26:09 -0400
Date: Fri, 30 Mar 2012 07:26:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v3 0/4] tools: Add a toplevel Makefile
Message-ID: <20120330052605.GA30508@merkur.ravnborg.org>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333023957-22746-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:25:53PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> 
> Hi all,
> 
> yet another version of the toplevel Makefile integration of tools/.
> This round gives you the ability to build the tools from the toplevel
> Makefile (explanation below can be found also in patch 4/4's commit
> message):
> 
> "Now you can do
> 
> $ make tools/<toolname>
Makes sense.
> 
> from the toplevel kernel directory and have the respective tool built.
> 
> If you want to build and install it, do
> 
> $ make tools/<toolname> tinstall
But this makes no sense.

It would be better to be consistent - so the user does not need to remember
when to add a space and when not.

make tools/<command> where <command> is one of help, install, clean, "nothing"
make tools/<toolname>
make tools/<toolname>_<comand> where command is the same set of commands


then a user could do:

    make tools/clean
    make tools/perf
    make tools/perf_install

or

    make tools/clean
    make tools/
    make tools/install


The install target could implicitly include the build target.

With this scheme the user is up to less suprises.

All the above are only minor adjustments compared to what you already did.
bt the consistency here is a gain (IMO).

	Sam
