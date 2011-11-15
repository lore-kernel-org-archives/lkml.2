Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab1KOS57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:57:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab1KOS56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:57:58 -0500
Date: Tue, 15 Nov 2011 13:57:28 -0500
From: Dave Jones <davej@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: How to remove 2000+ lines from 400+ defconfig files?
Message-ID: <20111115185728.GA16643@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michal Marek <mmarek@suse.cz>, Paul Bolle <pebolle@tiscali.nl>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
References: <1321362602.20271.192.camel@x61.thuisdomein>
 <alpine.LNX.2.00.1111151412360.15187@pobox.suse.cz>
 <1321371462.20271.201.camel@x61.thuisdomein>
 <4EC2B1F7.6090108@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC2B1F7.6090108@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 07:39:51PM +0100, Michal Marek wrote:

 > >> The only ones I'd have objections to taking immediately are those which are
 > >> actually still referenced somewhere in the code.
 > >> For those, either taking them through appropriate maintainers, or having
 > >> their Acked-by would be required.
 > >
 > > I don't mind. That shouldn't be a lot of extra work for me.
 > >
 > > But, I do have a naive question: are defconfigs meant to be drop in
 > > replacements for .config files or is one supposed to first feed them to
 > > the config tools to generate an up to date .config?
 > 
 > defconfig files are used as input of the conf program.

It seems to me that these files have always been very neglected.
Perhaps a better solution would be to have 'make defconfig' generate them itself.
This would mean adding addition 'default' parameters to a ton of
existing options, and possibly also some 'if CONFIG_$ARCH' magic, but
that sounds like it would be more future-proof, and would also serve
as better documentation. (As a distro kernel maintainer, the number of
times I've hit undocumented "enable this on arch x, but leave disabled on arch y" is annoying).

	Dave

