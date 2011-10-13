Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1JMEsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 00:48:33 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:45234 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab1JMEsb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 00:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <4E9614FA.20108@xenotime.net>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
 <1318325033-32688-3-git-send-email-sumit.semwal@ti.com> <4E9614FA.20108@xenotime.net>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Thu, 13 Oct 2011 10:18:10 +0530
Message-ID: <CAB2ybb8RTdUt8w2T74KH=hJoe9_tV41Ua_Z4x4kWa64OpXOe+A@mail.gmail.com>
Subject: Re: [RFC 2/2] dma-buf: Documentation for buffer sharing framework
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, jesse.barker@linaro.org,
        m.szyprowski@samsung.com, rob@ti.com, daniel@ffwll.ch,
        t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,
On Thu, Oct 13, 2011 at 4:00 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 10/11/2011 02:23 AM, Sumit Semwal wrote:
>> Add documentation for dma buffer sharing framework, explaining the
>> various operations, members and API of the dma buffer sharing
>> framework.
>>
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
>> ---
>>  Documentation/dma-buf-sharing.txt |  210 +++++++++++++++++++++++++++++++++++++
<snip>
>> +    if the new buffer-user has stricter 'backing-storage constraints', and the
>> +    exporter can handle these constraints, the exporter can just stall on the
>> +    get_scatterlist till all outstanding access is completed (as signalled by
>
>                       until
>
Thanks for your review; I will update all these in the next version.
>> +    put_scatterlist).
>> +    Once all ongoing access is completed, the exporter could potentially move
>> +    the buffer to the stricter backing-storage, and then allow further
>> +    {get,put}_scatterlist operations from any buffer-user from the migrated
>> +    backing-storage.
>> +
>> +   If the exporter cannot fulfill the backing-storage constraints of the new
>> +   buffer-user device as requested, dma_buf_attach() would return an error to
>> +   denote non-compatibility of the new buffer-sharing request with the current
>> +   buffer.
>> +
>> +   If the exporter chooses not to allow an attach() operation once a
>> +   get_scatterlist has been called, it simply returns an error.
>> +
>> +- mmap file operation
>> +   An mmap() file operation is provided for the fd associated with the buffer.
>> +   If the exporter defines an mmap operation, the mmap() fop calls this to allow
>> +   mmap for devices that might need it; if not, it returns an error.
>> +
>> +References:
>> +[1] struct dma_buf_ops in include/linux/dma-buf.h
>> +[2] All interfaces mentioned above defined in include/linux/dma-buf.h
>
>
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
Best regards,
~Sumit.
