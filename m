Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1AZNHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:07:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54245 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1AZNHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:07:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Rw+4ObH/FGgxLzFbqyEdh0v7wJZn1OB9fMbkLQAwcmIpOfSTM6y7oN9BDOV1eLtEYQ
         7/Ii6zFLuUq5DqbG3T3KC42dRUKxCRlJQXqiw3zCx71rKX7fFvduRDMjWskMF5b/B2IJ
         6OtRoeANQZc4wsZYvNMnK84xI/WscbLL2WS6Q=
Date: Wed, 26 Jan 2011 16:07:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in
 write_blk_fifo() function.
Message-ID: <20110126130718.GN2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
 <1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You didn't introduce it but do you know what the code is trying to do
here?

        byte_length = word_length * 4;

        if (byte_length % 4)
                aligncnt = 4 - (byte_length % 4);
        else
                aligncnt = 0;
        byte_length += aligncnt;

        if (byte_length && ((byte_length % 64) == 0))
                byte_length += 4;

        if (byte_length < 64)
                byte_length = 68;


Apparently the stuff has to be aligned to 4 bytes, but it can't be
aligned at 64 bytes and it can't be less than 68 bytes long.  The 
part that especially confuses me is why it can't be aligned at 64 bytes.

regards,
dan carpenter
