Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0H0Qeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:34:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36094 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0H0Qem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RF1o0o9WtIrGWQGci2THVJraAiZ3AzQDKjahFx43K/gdWPK87Pt7qGp/GW8uKbWmnV
         MGVD3abmpjIiB1Vn4G7asvIHoYN4EXO8P6TmE1rocUySfGzFUORCzhK6YiZWvqgcxUT0
         xQ0nUcr26fblJZ006PgZx6N4FyO/uPloeLzNQ=
Date: Fri, 27 Aug 2010 09:34:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        chatty@enac.fr, micki@n-trig.com
Subject: Re: [PATCH 4/4] firmware sysfs node
Message-ID: <20100827163436.GB13030@core.coreip.homeip.net>
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu>
 <1282798497-19791-5-git-send-email-rafi@seas.upenn.edu>
 <4C77AAE1.6050001@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C77AAE1.6050001@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 02:09:05PM +0200, Henrik Rydberg wrote:
> On 08/26/2010 06:54 AM, Rafi Rubin wrote:
> 
> > Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> > ---
> >  drivers/hid/hid-ntrig.c |   21 +++++++++++++++++++++
> >  1 files changed, 21 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> > index ab0ca7f..e341e88 100644
> > --- a/drivers/hid/hid-ntrig.c
> > +++ b/drivers/hid/hid-ntrig.c
> > @@ -375,6 +375,26 @@ static ssize_t set_deactivate_slack(struct device *dev,
> >  static DEVICE_ATTR(deactivate_slack, S_IWUSR | S_IRUGO, show_deactivate_slack,
> >  		   set_deactivate_slack);
> >  
> > +static ssize_t show_firmware(struct device *dev,
> > +			       struct device_attribute *attr,
> > +			       char *buf)
> > +{
> > +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> > +	struct ntrig_data *nd = hid_get_drvdata(hdev);
> > +
> > +	if (!(nd->firmware_version[0] || nd->firmware_version[1] ||
> > +	      nd->firmware_version[2] || nd->firmware_version[3]))
> > +		return sprintf(buf, "Firmware version unavailable");
> 
> 
> If this sysfs node should really be added (see EVIO), it is probably better if
> it returns the same format for all devices. If all numbers are zero, that is
> understandable also by someone reading the node.
> 

Yes, I think we should stick it into input_id and be done with it. Note
that input_id is not only available via EVIOCGID ioctl but also already
exported in sysfs.

-- 
Dmitry
