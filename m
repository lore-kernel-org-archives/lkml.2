Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2EMTSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 15:18:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20953 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab2EMTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 15:18:30 -0400
Date: Sun, 13 May 2012 22:21:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Volokh Konstantin <volokh84@gmail.com>
Cc: my84@bk.ru, devel@driverdev.osuosl.org, hverkuil@xs4all.nl,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mchehab@infradead.org, dhowells@redhat.com, justinmattock@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: media: go7007: Adlink MPG24 board
Message-ID: <20120513192148.GE16984@mwanda>
References: <1336935162-5068-1-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336935162-5068-1-git-send-email-volokh84@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 10:52:41PM +0400, Volokh Konstantin wrote:
> This patch applies only for Adlink MPG24 board with go7007, all these changes were tested for continuous loading & restarting modes
> 
> This is minimal changes needed for start up go7007 to work correctly
>   in 3.4 branch
> 
> Changes:
>   - When go7007 reset device, i2c was not working (need rewrite GPIO5)
>   - As wis2804 has i2c_addr=0x00/*really*/, so Need set I2C_CLIENT_TEN flag for validity
>   - some main nonzero initialization, rewrites with kzalloc instead kmalloc
>   - STATUS_SHUTDOWN was placed in incorrect place, so if firmware wasn`t loaded, we
>     failed v4l2_device_unregister with kernel panic (OOPS)
>   - some new v4l2 style features as call_all(...s_stream...) for using subdev calls
> 

In some ways, yes, I can see that this seems like one thing "Make
go7007 work correctly", but really it would be better if each of
the bullet points was its own patch.

The changelogs should explain why you do something not what you do.
We can all see that kmalloc() was changed to kzalloc() but why? Is
their and information leak for example?  That might have security
implications and be good thing to know about.

regards,
dan carpenter


