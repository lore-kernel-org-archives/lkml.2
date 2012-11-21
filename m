Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2KUPxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:53:40 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:49704 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2KUPxj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 21 Nov 2012 10:53:39 -0500
Message-Id: <50AD074A02000078000AA6B3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 21 Nov 2012 15:54:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: <xen-devel@lists.xen.org>, "Konrad Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH] xen: tmem: selfballooning should be
 enabled when xen tmem is enabled
References: <748aba10-531a-4ad5-bad3-7af0f86c0489@default>
 <50AC9CFF02000078000AA43C@nat28.tlf.novell.com>
 <6912a721-cd5b-4c12-91b2-795eb58ace66@default>
In-Reply-To: <6912a721-cd5b-4c12-91b2-795eb58ace66@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.11.12 at 16:42, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>>  From: Jan Beulich [mailto:JBeulich@suse.com]
>> Sent: Wednesday, November 21, 2012 1:21 AM
>> To: Dan Magenheimer
>> Cc: xen-devel@lists.xen.org; Konrad Wilk; linux-kernel@vger.kernel.org 
>> Subject: Re: [Xen-devel] [PATCH] xen: tmem: selfballooning should be enabled 
> when xen tmem is enabled
>> 
>> >>> On 20.11.12 at 23:42, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>> > Konrad: Any chance this can get in for the upcoming window?
>> > (Or is it enough of a bug fix that it can go in at an -rcN?)
>> >
>> > It was just pointed out to me that some kernels have
>> > cleancache and frontswap and xen_tmem enabled but NOT
>> > xen_selfballooning!  While this configuration should be
>> > possible, nearly all kernels that have CONFIG_XEN_TMEM=y should
>> > also have CONFIG_XEN_SELFBALLOONING=y, since Transcendent
>> > Memory (tmem) for Xen has very limited value without
>> > selfballooning.
>> >
>> > This is probably a result of a Kconfig mistake fixed I think
>> > by the patch below.  Note that the year-old Oracle UEK2 kernel
>> > distro has both CONFIG_XEN_TMEM and CONFIG_XEN_SELFBALLOONING
>> > enabled, as does a Fedora 17 kernel update (3.6.6-1.fc17), so
>> > the combination should be well tested.  Also, Xen tmem (and thus
>> > selfballooning) are currently only enabled when a kernel boot
>> > parameter is supplied so there is no runtime impact without
>> > that boot parameter.
>> >
>> > Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
>> >
>> > diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
>> > index d4dffcd..b5f02f3 100644
>> > --- a/drivers/xen/Kconfig
>> > +++ b/drivers/xen/Kconfig
>> > @@ -10,9 +10,9 @@ config XEN_BALLOON
>> >  	  return unneeded memory to the system.
>> >
>> >  config XEN_SELFBALLOONING
>> > -	bool "Dynamically self-balloon kernel memory to target"
>> 
>> Why would you want to take away the configurability of this?
>> You wanting it always on in your use case doesn't mean everyone
>> agrees. This would be the right way only when the option being
>> off despite all its dependencies being enabled is actively wrong.
> 
> I'd like it to be configurable, but my config steps
> (e.g. yes "" | make oldconfig, after enabling CLEANCACHE and
> FRONTSWAP and XEN_TMEM) failed to enable it.  Removing the
> prompt is the only thing that worked.

If all of the dependencies are enabled, then I can't see why the
prompt wouldn't show up.

> P.S. I removed the CLEANCACHE dependency because that dependency
> is present for XEN_TMEM and I assumed dependencies are transitive.

That's correct.

Jan

