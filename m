Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2BFOfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:35:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38263 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2BFOfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:35:11 -0500
Date: Mon, 6 Feb 2012 08:35:06 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/3] apple_bl: Convert printks to pr_<level>
Message-ID: <20120206143506.GB6414@ubuntu-macmini>
Mail-Followup-To: Ryan Mallon <rmallon@gmail.com>,
	linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
	Matthew Garrett <mjg@redhat.com>
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
 <1328300884-21551-2-git-send-email-seth.forshee@canonical.com>
 <4F2F0F61.7070900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2F0F61.7070900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 10:23:13AM +1100, Ryan Mallon wrote:
> On 04/02/12 07:28, Seth Forshee wrote:
> 
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  drivers/video/backlight/apple_bl.c |   29 ++++++++---------------------
> >  1 files changed, 8 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
> > index be98d15..66d5bec 100644
> > --- a/drivers/video/backlight/apple_bl.c
> > +++ b/drivers/video/backlight/apple_bl.c
> > @@ -16,6 +16,8 @@
> >   *  get at the firmware code in order to figure out what it's actually doing.
> >   */
> >  
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> >  #include <linux/module.h>
> >  #include <linux/kernel.h>
> >  #include <linux/init.h>
> > @@ -38,13 +40,6 @@ struct hw_data {
> >  
> >  static const struct hw_data *hw_data;
> >  
> > -#define DRIVER "apple_backlight: "
> > -
> > -/* Module parameters. */
> > -static int debug;
> > -module_param_named(debug, debug, int, 0644);
> > -MODULE_PARM_DESC(debug, "Set to one to enable debugging messages.");
> 
> 
> Removal of this module parameter is not noted in the changelog.
> 
> > -
> >  /*
> >   * Implementation for machines with Intel chipset.
> >   */
> > @@ -58,9 +53,7 @@ static int intel_chipset_send_intensity(struct backlight_device *bd)
> >  {
> >  	int intensity = bd->props.brightness;
> >  
> > -	if (debug)
> > -		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
> > -		       intensity);
> > +	pr_debug("setting brightness to %d\n", intensity);
> 
> 
> As Joe points out, this no longer has the same behaviour as it did
> previously. The pr_debug will only show up if you have DEBUG defined.
> Again, this should probably be mentioned in the changelog.

I doesn't matter to me one way or the other whether these statements are
enabled by module parameter, I was just thinking that pr_debug was
generally preferred. I can put the module parameter back or denote this
in the changelog, whichever is more acceptable.

Seth
