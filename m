Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1AWR7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 12:59:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61825 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1AWR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 12:59:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rdHavq5EIvk2uhr6rdMIZzH26vG1N7veeP/PJ/BcKXDjSXN2KEYeOs7qJo2I2vf21Q
         WPTd53Vs6EGWQ6STJbHPFro+sopMm1JnnuK6ZFWfVm7AG+FGcZhowIV5UDIlXitVBdaE
         tOlD4NTHzX1x+yh3X75D7Lp2nm20GWFhkcqT8=
Date: Sun, 23 Jan 2011 18:59:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Message-ID: <20110123175945.GA1760@nowhere>
References: <20110123011221.GB1805@nowhere>
 <1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 11:01:12AM +0000, Chris Wilson wrote:
> We can only utilize the stolen portion of the GTT if we are in sole
> charge of the hardware. This is only true if using GEM and KMS,
> otherwise VESA continues to access stolen memory.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Tested-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
> 
> Frederic, updated patch attached. The bug was that clear_range took (start,
> count) and I was passing in (start, end) so we were dereferencing past the
> end of the valid pages.
> -Chris

Works well, thank you :)

Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
