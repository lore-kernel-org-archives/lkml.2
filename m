Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1BIAeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:34:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40765
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756054Ab1BIAer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:34:47 -0500
Date: Tue, 08 Feb 2011 16:35:22 -0800 (PST)
Message-Id: <20110208.163522.232741523.davem@davemloft.net>
To: toshiharu-linux@dsn.okisemi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        tomoya-linux@dsn.okisemi.com
Subject: Re: [PATCH] pch_gbe: Fix the issue that the receiving data is not
 normal.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D50FDAA.1060506@dsn.okisemi.com>
References: <4D50FDAA.1060506@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Tue, 08 Feb 2011 17:24:10 +0900

> Hi Devid
> 
> I resubmit this patch modified.
> Please check them.

Your memcpy+memcpy sequences are equivalent to memmove(), please
use that instead.

I have to say this function is insanely complicated.  There seems
to be 16 different ways RX packets are processed.  I can't believe
that is needs to be like this.
