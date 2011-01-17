Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1AQGGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:06:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60647 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1AQGGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:06:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=GHXMMYW4dEMlz9INQCLhliCfYe4YhkXsYk0IOV5wkctpf41E75tX2OLT7Rj9ZR6FAh
         gk3W9z+pR7hJuStuAchKJGFCY/mruXWMKk7P3fy9gWgl1aeysikLRP46wPEJ/3dqpBJh
         2DbmEEIYa6+vGQ/3YACwD/LuOTWCEOvnP5M4s=
Date: Mon, 17 Jan 2011 09:06:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: question about smatch error
Message-ID: <20110117060601.GH2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
References: <adar5ccyver.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar5ccyver.fsf@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 09:02:52PM -0800, Roland Dreier wrote:
> where eui is a u8*, and I don't see how smatch even thinks it knows how
> big the buffer is in the first place.
> 

It comes from the memcpy:

        memcpy(eui, dev->dev_addr, 3);
        memcpy(eui + 5, dev->dev_addr + 3, 3);

The first line means smatch thinks "eui" is a 3 char buffer.  The second
line gets ignored but normally smatch would see "eui + 5" as a separate
buffer.

Really when it sees the memcpy() that's just a guess about the size, 
I'll disable it by default unless you use the --spammy option.

regards,
dan carpenter

