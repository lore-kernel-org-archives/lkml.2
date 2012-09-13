Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab2IMIiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:38:07 -0400
Received: from mx0.aculab.com ([213.249.233.131]:37580 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757011Ab2IMIiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:38:01 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 9/9] drivers/isdn/gigaset/common.c: Remove useless kfree
Date: Thu, 13 Sep 2012 09:31:45 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6FEE@saturn3.aculab.com>
In-Reply-To: <1347462407-13499-9-git-send-email-peter.senna@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 9/9] drivers/isdn/gigaset/common.c: Remove useless kfree
thread-index: Ac2Q+LiMR6FwsOJ9QWaZy3KW61RewgAkR1fQ
References: <1347462407-13499-9-git-send-email-peter.senna@gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Peter Senna Tschudin" <peter.senna@gmail.com>,
        "Hansjoerg Lipp" <hjlipp@web.de>
Cc: <kernel-janitors@vger.kernel.org>, "Tilman Schmidt" <tilman@imap.cc>,
        "Karsten Keil" <isdn@linux-pingi.de>,
        <gigaset307x-common@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove useless kfree() and clean up code related to the removal.
...
> diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
> index aa41485..30a6b17 100644
> --- a/drivers/isdn/gigaset/common.c
> +++ b/drivers/isdn/gigaset/common.c
> @@ -1123,7 +1123,6 @@ struct gigaset_driver *gigaset_initdriver(unsigned minor, unsigned minors,
>  	return drv;
> 
>  error:
> -	kfree(drv->cs);
>  	kfree(drv);
>  	return NULL;
>  }
> 

Seems to me that (assuming kfree(NULL) is ok) the kfree()
is best left in - just in case some other error path is
added after drv->cs is assigned.
Better safe than a memory leak.

	David



