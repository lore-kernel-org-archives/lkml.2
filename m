Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1KONC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:02:26 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:38861 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1KONCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 08:02:25 -0500
Message-ID: <4EC262DD.1070502@ladisch.de>
Date: Tue, 15 Nov 2011 14:02:21 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix truncated entity specification
References: <4EB5ADA9.6010104@ladisch.de> <201111150148.07957.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111150148.07957.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> On Saturday 05 November 2011 22:42:01 Clemens Ladisch wrote:
> > When enumerating an entity, assign the entire entity specification
> > instead of only the first two words.  (This requires giving the
> > specification union a name.)
> 
> What about this (untested) simpler patch ?
> 
> -	u_ent.v4l.major = ent->v4l.major;
> -	u_ent.v4l.minor = ent->v4l.minor;
> +	memcpy(&u_ent.raw, &ent->raw, sizeof(u_ent.raw));

I would have written it this way if ent->raw actually existed.
(And please don't tell me you want to increase the size of
struct media_entity by 172 bytes.  :)


Regards,
Clemens
