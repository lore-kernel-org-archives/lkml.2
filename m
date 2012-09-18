Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab2IRQIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:08:30 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:37331 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2IRQI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:08:27 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiW/ABOcWFBV5h1yPGdsb2JhbABFhSAjhQCuOoI6AQECgQMZAQEBAR8ZDSeCIQEFJxMcIxAIA0YUJQoaiBe6ZBSLOQU2M4Eug0JgA5VihXCDRolU
X-IronPort-AV: E=Sophos;i="4.80,443,1344204000"; 
   d="scan'208";a="411427805"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 18 Sep 2012 18:16:15 +0200
To: Kevin Daughtridge <kevin@kdau.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbhid: call report_fixup before comparing descriptors
Message-ID: <20120918161615.GA1439@polaris.bitmath.org>
References: <50578272.1020902@kdau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50578272.1020902@kdau.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> @@ -1436,6 +1436,10 @@ static int hid_post_reset(struct usb_int
>          kfree(rdesc);
>          return 1;
>      }
> +
> +    if (hid->driver && hid->driver->report_fixup)
> +        rdesc = hid->driver->report_fixup(hid, rdesc, &status);
> +
>      status = memcmp(rdesc, hid->rdesc, hid->rsize);

You can use dev_rdesc here instead.

Thanks,
Henrik
