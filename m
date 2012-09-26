Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab2IZJkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:40:51 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49316 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2IZJku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:40:50 -0400
X-AuditID: b753bd60-932c5ba0000047ca-aa-5062cd9f14bd
X-AuditID: b753bd60-932c5ba0000047ca-aa-5062cd9f14bd
Message-ID: <5062CD93.8090600@hitachi.com>
Date: Wed, 26 Sep 2012 18:40:35 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Amit Shah <amit.shah@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/3] virtio_console:Merge struct buffer_token into struct
 port_buffer
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com> <1348580837-10919-2-git-send-email-sjur.brandeland@stericsson.com> <50626C11.9040708@hitachi.com> <81C3A93C17462B4BBD7E272753C1057923BD8365F7@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057923BD8365F7@EXDCVYMBSTM005.EQ1STM.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/26 16:48), Sjur BRENDELAND wrote:
>>> -static struct port_buffer *alloc_buf(size_t buf_size)
>>> +static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
>>> +				     int nrbufs)
>>>  {
>>>  	struct port_buffer *buf;
>>> +	size_t alloc_size;
>>>
>>> -	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
>>> +	/* Allocate buffer and the scatter list */
>>> +	alloc_size = sizeof(*buf) + sizeof(struct scatterlist) * nrbufs;
>>
>> This allocates one redundant sg entry when nrbuf > 0,
>> but I think it is OK. (just a comment)
> 
> I did this on purpose for the sake of simplicity, but I can
> change this to something like:
> 	 alloc_size = sizeof(*buf) + sizeof(buf->sg) * max(nrbufs - 1, 1);

You wouldn't need to change that. I think current code is enough simple
and reasonable. :)

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


