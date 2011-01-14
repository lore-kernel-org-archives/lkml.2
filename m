Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab1ANRuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:50:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42225 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab1ANRt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:49:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mI1Mdrvb2+s/1kmcxMsGom2+UfxJS+Ofs7JoKZjDcwFGWj7dWM31m2ozkvCwbuka4C
         TtpHEZY6LcQ+8VTmRzQyLfI3eEIozdynaZNJzTtkuKGbuVZW1vBThppF1Bm3WRjVkJBB
         253pePvTvuLfiGRYa0Kny3A2ky7YCrcaR16fc=
Date: Fri, 14 Jan 2011 18:49:40 +0100
From: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: [radeon] radeon_kick_out_firmware_fb() can deref NULL
Message-ID: <20110114174940.GA9168@begonia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In commit a56f7428d7534f162fbb089c5c79012bf38a7c29 [1], the result of
alloc_apertures() function call is used without checking for a possible NULL
result, which may happen, as seen in [2].

The latest commit [3] in the drm-fixes branch of the
linux/kernel/git/airlied/drm-2.6.git repo still has the issue.

[1] http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=a56f7428d7534f162fbb089c5c79012bf38a7c29
[2] http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;hb=refs/heads/drm-fixes;a=blob;f=include/linux/fb.h#l890
[3] http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=d15eda5c6edff4987af6f4423af0bab0c3251e74

Regards,
Sylvain "ythier" Hitier

-- 
Free hugs for Free Software Fellows!
Living in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
