Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2BFS0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:26:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48920 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2BFS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:26:24 -0500
Message-ID: <4F301B93.4030306@gmail.com>
Date: Mon, 06 Feb 2012 19:27:31 +0100
From: Chase Douglas <chasedouglas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Input: Add EVIOC mechanism for MT slots
References: <1328515542-3779-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1328515542-3779-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 09:05 AM, Henrik Rydberg wrote:
> This patch adds the ability to extract MT slot data via a new ioctl,
> EVIOCGMTSLOTS. The function returns an array of slot values for the
> specified ABS_MT event type.
> 
> Example of user space usage:
> 
> struct { unsigned code; int values[64]; } req;
> req.code = ABS_MT_POSITION_X;
> if (ioctl(fd, EVIOCGMTSLOTS(sizeof(req)), &req) < 0)
> 	return -1;
> for (i = 0; i < 64; i++)
> 	printf("slot %d: %d\n", i, req.values[i]);
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Here is the fourth version of the patch.
> 
> Rather than over-specifying the ioctl binary format by introducing a
> struct object that does not fit everyone, this version simply leaves
> all object definitions to userland.

This is fine with me. I think the ioctl macro definition would be easier
to work with if it took the number of values instead of the size of the
request, but it's a nit-pick. If Dmitry thinks this is good enough, it's
good enough for me too :).

Reviewed-by: Chase Douglas <chase.douglas@canonical.com>

Thanks!
