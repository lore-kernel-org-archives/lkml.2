Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0IACGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:06:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47454 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0IACGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=awqx1tWiQqBnNNCkiFybeas3vkftsSnROfm3Tl7i0WhRnrXZFhNlGoWTstWEvQt2fw
         rKSAIJSbbeqfgLpcjqbnuvuta1kzDZMpOreORaUR9uNTANQofks6r39PNZ9O1emg2yXL
         awsJZImUlRQF8DRLF+OTY5VhWC0KdjTuJPXFk=
Date: Tue, 31 Aug 2010 19:06:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: jkosina@suse.cz, Henrik Rydberg <rydberg@euromail.se>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        chatty@enac.fr, micki@n-trig.com
Subject: Re: [PATCH 4/4] firmware sysfs node
Message-ID: <20100901020634.GD23585@core.coreip.homeip.net>
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu>
 <1282798497-19791-5-git-send-email-rafi@seas.upenn.edu>
 <4C77AAE1.6050001@euromail.se>
 <20100827163436.GB13030@core.coreip.homeip.net>
 <4C7C639F.3040407@seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7C639F.3040407@seas.upenn.edu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 10:06:23PM -0400, Rafi Rubin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 08/27/10 12:34, Dmitry Torokhov wrote:
> > On Fri, Aug 27, 2010 at 02:09:05PM +0200, Henrik Rydberg wrote:
> >> On 08/26/2010 06:54 AM, Rafi Rubin wrote:
> >>
> >>> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> >>> ---
> >>>  drivers/hid/hid-ntrig.c |   21 +++++++++++++++++++++
> >>>  1 files changed, 21 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> >>> index ab0ca7f..e341e88 100644
> >>> --- a/drivers/hid/hid-ntrig.c
> >>> +++ b/drivers/hid/hid-ntrig.c
> >>> @@ -375,6 +375,26 @@ static ssize_t set_deactivate_slack(struct device *dev,
> >>>  static DEVICE_ATTR(deactivate_slack, S_IWUSR | S_IRUGO, show_deactivate_slack,
> >>>  		   set_deactivate_slack);
> >>>  
> >>> +static ssize_t show_firmware(struct device *dev,
> >>> +			       struct device_attribute *attr,
> >>> +			       char *buf)
> >>> +{
> >>> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> >>> +	struct ntrig_data *nd = hid_get_drvdata(hdev);
> >>> +
> >>> +	if (!(nd->firmware_version[0] || nd->firmware_version[1] ||
> >>> +	      nd->firmware_version[2] || nd->firmware_version[3]))
> >>> +		return sprintf(buf, "Firmware version unavailable");
> >>
> >>
> >> If this sysfs node should really be added (see EVIO), it is probably better if
> >> it returns the same format for all devices. If all numbers are zero, that is
> >> understandable also by someone reading the node.
> >>
> > 
> > Yes, I think we should stick it into input_id and be done with it. Note
> > that input_id is not only available via EVIOCGID ioctl but also already
> > exported in sysfs.
> 
> The version in input_id is only 16 bits, whereas the ntrig version codes seem to
> be 32 bits.  Actually I've only mapped 21 bits out of 64, but I figure the first
> and last 8 are not actually part of the version, but that's still more than 16.
> 
> So, would you prefer that I increase the size of that field, or keep the
> firmware version code separate?
> 

Hmm, changing size would require ABI change which I am hesitant to do
without _very_ good reason.

If debugging aid is the only purpose maybe we should just dump the data
into dmesg and be done with it.

> 
> Also does it make sense to have a provide a pretty printer in the kernel, or
> should that be left to userspace?  The hardware returns a raw version code in
> the form:
> 	1a08 a521
> 
> In the ntrig utilities and documentation the where firmware version is mentioned
> it looks more like this:
> 	4.6.17.13.5
> 
> My intent was to make that second form more accessible to keep things simple for
> users, who if they are checking that probably already have enough troubling them :)
> 

Yeah, splitting into segments is pretty cheap.

-- 
Dmitry
