Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2FTAzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 20:55:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37597 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2FTAzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 20:55:03 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-92-4fe11f5aad75
From: Jingoo Han <jg1.han@samsung.com>
To: "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501cd4de5$d955a290$8c00e7b0$%han@samsung.com>
 <4FE11D60.9040109@gmx.de>
In-reply-to: <4FE11D60.9040109@gmx.de>
Subject: Re: [PATCH] video: exynos_dp: fix build warning due to uninitialized
 value
Date: Wed, 20 Jun 2012 09:54:49 +0900
Message-id: <000001cd4e7f$4b9a29e0$e2ce7da0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1Ofh/N5jrba9K9SHyVjpa7sY40+AAAM3Gg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd0o+Yf+Bue/c1mc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKaPr9jK3jFVtHT9oG1gXEBaxcjJ4eEgInElHO32SBs
	MYkL99YD2VwcQgLTGSW+be+Ecn4xSkz88ZkJpIpNQE3iy5fD7F2MHBwiAlYSm7ZqgtQwC7Qx
	Spw/OYMZpEZIIFJi+YUTYDYnUP3HmafBeoUFQiVu72oA28YioCpx7v9vFhCbV8BW4uzLU+wQ
	tqDEj8n3wOLMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXYgTjCQ6zlhCVIhI7HvxjnECo9As
	JINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDuhn0jsYVzVYHGIU
	4GBU4uE9w/XQX4g1say4MvcQowQHs5IIb/+XB/5CvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZus
	L/gLCaQnlqRmp6YWpBbBZJk4OKUaGMUSd88U+h7fYusxvSDkt5prkuSNrRaFJlcZz9564VZQ
	Ua+eoljCOO/JCSZb4xktQu11FSGvRXZk7ErzdF6+5KQGr7f67AnzmMLNFE6vb+DRVAoSuKvM
	tUD5r+tn0SipLStXRNY7638PPLDMeDnj+U8l24PlLzPWbU48nBr35LJl7vOrN19wKrEUZyQa
	ajEXFScCACbG1KhkAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, June 20, 2012 at 9:46 AM, Florian Tobias Schandinat wrote:

> Hi Jingoo,
> 
> On 06/19/2012 06:36 AM, Jingoo Han wrote:
> > This patch fixes build warning due to uninitialized value dereference.
> > @@ -407,6 +407,8 @@ static unsigned int exynos_dp_get_lane_link_training(
> >  	case 3:
> >  		reg = exynos_dp_get_lane3_link_training(dp);
> >  		break;
> > +	default:
> > +		return -EINVAL;
> 
> Why do you consider returning -EINVAL here a good idea? As far as I can
> see the caller does not check the return value for an error condition
> and I doubt that the hardware understands what -EINVAL means. If you
> want to fix the warning, make sure that you don't hide actual errors,
> add an WARN or BUG or make sure the error code makes it to userspace.
> 

OK, I will fix it and send the v2 patch.
Thank you.

Best regards,
Jingoo Han


