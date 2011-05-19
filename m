Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1ESMfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:35:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46273 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab1ESMfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B94vbjGksymEawl4ZeU974Ewh10Y5CX7WuMYJHIx/fxdgk0UvFfKIyDKXT8ZtXlpLG
         +5bvjcSA3frs7lA4xixKhFRcQ2qebYUJ4CmHzE+uQtr45HiYfl0W4oeX0OOt4cp4uDDs
         IiVl7dap3VsJK64MMbLTXv0F/HvqtIxoM4aLY=
MIME-Version: 1.0
In-Reply-To: <20110519110105.GB25179@zod.rchland.ibm.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	<20110519110105.GB25179@zod.rchland.ibm.com>
Date: Thu, 19 May 2011 07:35:11 -0500
Message-ID: <BANLkTi=08fugm=kpP7LNQc+eRaOuOYR1-w@mail.gmail.com>
Subject: Re: [PATCH 1/7] [RFC] Mainline BG/P platform support
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 6:01 AM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> On Wed, May 18, 2011 at 04:24:49PM -0500, Eric Van Hensbergen wrote:
>>
>>I'll be maintaining the patchset in my kernel.org repository
>>(/pub/scm/linux/kernel/git/ericvh/bluegene.git) under the bluegene
>>branch with the source repos (zepto, kittyhawk, ibmcn) available in
>>respective branches.  Ben - if you would prefer me to send pull requests
>>once we get rolling, I can switch to that -- otherwise I'll stick to
>>just submitting patches to the list assuming you'll pull them when they
>>become acceptable.  Thanks for your attention reviewing these patches.
>
> This is going to get slightly messy if there are lots of changes in
> platforms/44x and/or head_44x.S.  Most 4xx changes go through my tree,
> and I'm happy to pull from your tree once things get off the ground.  We
> just need to make sure and coordinate as we go.
>

I'm fine with processing the changes through your tree.  Most of the items
with conflicts are in this series, so hopefully it won't be too messy (outside
of some Makefile and Kconfig changes which are much easier to merge)
after this.  So, should I base changes on:
http://git.kernel.org/?p=linux/kernel/git/jwboyer/powerpc-4xx.git;a=shortlog;h=refs/heads/next
or:
http://git.kernel.org/?p=linux/kernel/git/benh/powerpc.git;a=shortlog;h=refs/heads/next

There are some important questions on code organization which it would
probably be a good idea to discuss at some point -- in particular what I
should do about the device drivers.  Pretty much every driver except for
the ethernet is particular to this platform.  IIRC some of the embedded
platforms have the SOC drivers in the platforms directory -- but it doesn't
seem like you've done this with 4xx so I was gonna just place them in
the appropriate drivers/* directory.  The other question is that there are
a number of patches which involve communication which a somewhat
substantial firmware layer.  You can get an idea of the existing patch's
code organization by looking at:

http://git.kernel.org/?p=linux/kernel/git/ericvh/bluegene.git;a=commit;h=bee9f329eeef6c8eb95c35de4c5d22a0c05a1b3e

Its important to point out that I am going through and cleaning up as I
go, so not everything from that patch will make the cut as is (or perhaps
even at all) -- but that should help identify where potential conflicts are
as well as potentially out of place code.

>>
>>+LINUX FOR POWERPC BLUEGENE/P
>>+M:    Eric Van Hensbergen <ericvh@gmail.com>
>>+W:    http://bg-linux.anl-external.org/wiki/index.php/Main_Page
>>+L:    bg-linux@lists.anl-external.org
>>+T:    git git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/bluegene.git
>>+S:    Maintained
>>+F:    arch/powerpc/platforms/44x/bgp*
>
> This should probably be the last patch in the series.  You have a file
> pattern listed for files that don't exist at all in any of the other
> patches you submitted :).
>

Yeah, I wondered about that, its just I hate patch series intro messages with
no patch, and I figured this was a good way out of it.  It also adds
the relevant
info as far as mailing lists and wiki pages where folks can go for more info --
but if folks have a problem with it I'll kill it until we get
everything else in.

     -eric
