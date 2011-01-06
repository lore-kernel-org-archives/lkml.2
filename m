Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1AFMyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:54:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab1AFMyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:54:14 -0500
Date: Thu, 6 Jan 2011 13:54:12 +0100
From: Michal Marek <mmarek@suse.cz>
To: Patrick LeBoutillier <patrick.leboutillier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bug in scripts/package/mkspec?
Message-ID: <20110106125412.GB1841@sepie.suse.cz>
References: <AANLkTin01j5oTUdh6fAgs--Gi46BZOWZCdypUPd8uhm4@mail.gmail.com>
 <4CF7BA6D.60002@suse.cz>
 <AANLkTinK9dKnSZdkH57dZNMysg0uVu7DfNtmmZdG8HZD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinK9dKnSZdkH57dZNMysg0uVu7DfNtmmZdG8HZD@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 04:15:20PM -0500, Patrick LeBoutillier wrote:
> Hi Michal,
> 
> Sorry for the bad patch. Here is basically what I do:
> 
> $ make menuconfig
> $ make rpm
> ...
> Wrote: /root/rpmbuild/RPMS/x86_64/kernel-2.6.36.1-1.x86_64.rpm
> ...
> $ make menuconfig # tweak some configs
> $ make rpm
> ...
> Wrote: /root/rpmbuild/RPMS/x86_64/kernel-2.6.36.1-1.x86_64.rpm
> ...
> 
> 
> My expectation (and perhaps it is incorrect) is that subsequent "make
> rpm"s on the same build tree
> yield rpms with increasing release numbers (2.6.36.1-1, 2.6.36.1-2,
> ...). Is this how it's supposed
> to work?

I see the problem now, unfortunatelly I haven't yet found a fix. The
problem is that the .version file is updated during build, but rpm needs
to know the release number in advance. The fact that there are about
four places that deal with the .version file is also not helping :-(.

Michal
