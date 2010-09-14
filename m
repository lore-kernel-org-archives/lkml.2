Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0INAwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:52:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45920 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab0INAwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b7d53guD7clK+40zsN7xG39kipl+D6VlXtkdl26XGBuB1ZTGsSIhczHE5RnDCfVWGP
         Jp6RF42mrZhP22PSpoJr2K/Ec7u0h9Poc0R95ZBuxpIsju4iuOLPLKBUp31VZJq2UpCC
         jF75y+3mRTEORPuaEJx2lx8BETl1yvgA6HICU=
Date: Mon, 13 Sep 2010 17:52:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, pingc@wacom.com,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
Message-ID: <20100914005209.GB27540@core.coreip.homeip.net>
References: <4C8E180D.4020309@suse.cz>
 <201009131656.18199.oneukum@suse.de>
 <20100913171046.GA23116@core.coreip.homeip.net>
 <201009132120.23372.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009132120.23372.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 09:20:23PM +0200, Oliver Neukum wrote:
> Am Montag, 13. September 2010, 19:10:47 schrieb Dmitry Torokhov:
> 
> > I think this introduces significant change in behavior though - before
> > we did not do usb_autopm_put_interface() on successful open, basically
> > disabling autopm facilities, right?
> 
> Right. Which makes no sense at all. You'd better remove anything related
> to runtime PM and not set supports_autosuspend for that.
> 

That not what I meant, I do not want to remove autopm, it's just it was
effectively disabled and if we fix it we might start getting some
regression reports ;)

-- 
Dmitry
