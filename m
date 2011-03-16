Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab1CPNsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:48:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48618 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1CPNsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fwAvBxCrR0lqiwWtHWf4oFQLQvWRXpBtRahWvHLCep6rHbznJozMeRe/veVOFmuVho
         BI78oOzf+Ry+6zwH8xM+QM7mbM+9y09/VNyxYnHoDlWU0OuMcNg1+7Uc6q0pA8WNujXJ
         sGNoO3rWKdVREok1miqZ+zW8/c0ETilkyToQ0=
Date: Wed, 16 Mar 2011 16:48:02 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein@nvidia.com
Cc: olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: bq20z75: fix issues with present and suspend
Message-ID: <20110316134802.GA15626@oksana.dev.rtsoft.ru>
References: <1299716282-21857-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1299716282-21857-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 04:18:02PM -0800, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> There are a few issues found around the battery not being present. If the
> battery isn't present, then a few undesirable things happen. The first was
> excessive reporting of failed properties. This was fixed by instead returning
> ENODATA for all properties other than PRESENT if the battery isn't present.
> That way the callers can identify the difference between a failure and the
> battery not being there.
> 
> The next issue was in the suspend logic. It was found that if the battery wasn't
> present, then it would return a failure, preventing the system from going into
> suspend. If there is no battery present, the io is expected to fail, so in that
> case, we shouldn't return the failure and just acknowledge that it was expected.
> 
> I also found that when a gpio was used, i didn't maintain the internal
> is_present state properly. I added a set of that to fix that.
> 
> Lastly, the code to see io's fail and figure out that the battery isn't present
> when not using a gpio had a problem. In that code, it looked for the read to
> fail and if it did, then handled it. The problem is that in function to get the
> property, it first writes a value and that write can fail, causing the code
> to never reach the logic after the read. Fix is to move the logic till after
> the write.
> 
> Change-Id: I09c9a9f0c1f0bcbad2308b6ffc65f6823d6a7ad0
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---

Applied, thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
