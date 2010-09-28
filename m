Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab0I1TBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:01:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab0I1TBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:01:52 -0400
Date: Tue, 28 Sep 2010 15:01:26 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Manu Abraham <abraham.manu@gmail.com>, Scott Davilla <davilla@4pi.com>,
        Lars Lindley <lindley@coyote.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: crystalhd: fix signed bug
Message-ID: <20100928190126.GG8726@redhat.com>
References: <1284317813-4895-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284317813-4895-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 10:56:51PM +0400, Vasiliy Kulikov wrote:
> chd_dec_major is unsigned, so check chd_dec_major < 0 doesn't make sense.
> Since it is used as signed, declare it as int.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Indeed, Bad Things here when we try to store the ret from register_chrdev
in an unsigned int and test it for < 0...

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

