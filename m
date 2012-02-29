Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031193Ab2B2PbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:31:15 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:37271 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031111Ab2B2PbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:31:14 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Feb 2012 10:31:13 EST
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: s4L0.CwVM1mcRpZhx1Wx8wmiTXsI5BpOnA9aAL4bJ5IeAAq
 9HAjMh7TJgwruOokOoBkqfURk9DpMan8BiLVX4CCCl9ArBHKnOu6S0dL_kXH
 Ru.RFBgRGAqQij3jG1vhla6hPURrj4PUyjIPgptC9eYFV_dqbEY0zVA6c2N1
 D5Bstd5SfLhcMwxSKnLLfobPbRkIoyBPP2FAHwpSm6_KJsZMHCGECXnYjkvg
 cNpTyvGe2.QxTkKdo46Eutl5Ynvfk1B1EAI8VEwXT4OtHQv9TWLh9pOTOsuR
 Uh.B18ep3SKK1lD7blpg5dOmmsKhBwWRCZWqnIduSUNUXGHa8.fD89mNQbkE
 _WKWPL7S0mZym5IMaKAXNAsQB8O7_Gqruk4.7SydjmqNRO5SN_vnsM.CdI59
 WLw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 29 Feb 2012 09:24:30 -0600 (CST)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Namhyung Kim <namhyung.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] slub: set PG_slab on all of slab pages
In-Reply-To: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com>
Message-ID: <alpine.DEB.2.00.1202290922210.32268@router.home>
References: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Namhyung Kim wrote:

> Unlike SLAB, SLUB doesn't set PG_slab on tail pages, so if a user would
> call free_pages() incorrectly on a object in a tail page, she will get
> confused with the undefined result. Setting the flag would help her by
> emitting a warning on bad_page() in such a case.

NAK

You cannot free a tail page of a compound higher order page independently.
You must free the whole compound.

