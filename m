Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0LMW5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:57:19 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:26597 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0LMW5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:57:17 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>, Jesper Juhl <jj@chaosbits.net>,
        Ky Srinivasan <ksrinivasan@novell.com>
Subject: RE: [PATCH 1/1] hv: Use only one txf buffer per channel and kmalloc
 on initialize
Thread-Topic: [PATCH 1/1] hv: Use only one txf buffer per channel and
 kmalloc on initialize
Thread-Index: AQHLmwp4yLbHTb01E0ye4GCCvXnmhJOfczGA//+Ig3A=
Date: Mon, 13 Dec 2010 22:57:10 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5622C0BCF70@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1292274861-29673-1-git-send-email-hjanssen@microsoft.com>
 <20101213220333.GA1636@ioremap.net>
In-Reply-To: <20101213220333.GA1636@ioremap.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.71]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
>From: Evgeniy Polyakov [mailto:zbr@ioremap.net] 
>Sent: Monday, December 13, 2010 2:04 PM
>
>On Mon, Dec 13, 2010 at 01:14:21PM -0800, Hank Janssen (hjanssen@microsoft.com) wrote:
>> +static u8 *shut_txf_buf;
>> +static u8 *time_txf_buf;
>> +static u8 *hbeat_txf_buf;
>
>Those are accessed without any kind of synchronization. I do not know exact context, but are you sure it is single-threaded?

The hv_utils driver services are all single threaded. The other drivers are not, but this one is.

Hank.


