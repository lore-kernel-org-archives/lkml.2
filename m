Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2GZVpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:45:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2GZVpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:45:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yaniv Gardi <ygardi@codeaurora.org>
Subject: Re: [PATCH v8 1/2] block: ioctl support for sanitize in eMMC 4.5
Date: Thu, 26 Jul 2012 13:36:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <1343208766-8046-1-git-send-email-ygardi@codeaurora.org> <1343208766-8046-2-git-send-email-ygardi@codeaurora.org>
In-Reply-To: <1343208766-8046-2-git-send-email-ygardi@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207261336.32018.arnd@arndb.de>
X-Provags-ID: V02:K0:MXNxMlBAI7/PJWWqA/iD/+l+nzQ/U5EmjWRGJGMsTdN
 EoDlUVzzUuRgCLl+wARhcYfUDqU//C4mGxECZFMlK4Easx9G4L
 gYJ31Xm+dZ2EMv/qOkKVjpYgoIvH8HocFcUPi24A/pWyfCPlvD
 yyDfveotRFBqkQi8HbhDD4YvQ4El+mb/6Q3p1Y+XJBODMdSbJg
 4pInpmS3TFvNU/9cRHMu6CaPKfDsMWl0FSg43UaarGIeI5c+EJ
 /cMFKFpmoPj9dlyTP5DYQkyOceYXiiMzerS4o7CVjNL99dt1kN
 ktrrKNN285GeJZRJ5klJ6pPkrWS41EqMcgLyQHLmbQEhoq1hGC
 o6DFB088XdMAHfCgMDIw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2012, Yaniv Gardi wrote:
> 
> Adding a new ioctl to support sanitize operation in eMMC
> cards version 4.5.
> The sanitize ioctl support helps performing this operation
> via user application.
> 
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> 

Can you explain how you expect this to be called by a file system?
We've debated this in the past and concluded that we probably
want to do it at the same time as batched discard, but I don't
see if the sanitize request should be sent for each FITRIM
or whether we should better have a separate file system level
ioctl. My feeling is that it would be more useful to call this
feature through a file system level ioctl than through a block
level ioctl, but I guess it makes sense to support both.

	Arnd

