Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672Ab2JWVLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:11:35 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:54312 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933658Ab2JWVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:11:32 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail04.sonyusa.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzzz2fh2a8h668h839hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
Message-ID: <508705BE.2020403@am.sony.com>
Date: Tue, 23 Oct 2012 14:01:50 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Ezequiel Garcia <elezegarcia@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/2] mm/slob: Mark zone page state to get slab usage at
 /proc/meminfo
References: <1350907434-2202-1-git-send-email-elezegarcia@gmail.com> <0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com> <CALF0-+VqGrcjw16rNPH459YAj7dubQnruzV-zOzYn6feOtQ4tQ@mail.gmail.com> <0000013a8ed646c2-4cc34bd5-19c3-4e99-9fa0-248cdbc24feb-000000@email.amazonses.com> <CALF0-+WASdSAT9rnLxx8OmHrNV5tjrDwpBTE9irCRd91QxMkBA@mail.gmail.com> <0000013a8f524097-4ebaed3b-0d77-4183-a6ad-f01b8855f9bf-000000@email.amazonses.com>
In-Reply-To: <0000013a8f524097-4ebaed3b-0d77-4183-a6ad-f01b8855f9bf-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 1:31 PM, Christoph Lameter wrote:
> On Tue, 23 Oct 2012, Ezequiel Garcia wrote:
>
>> The issue is: with SLUB large kmallocs don't set NR_SLAB_UNRECLAIMABLE
>> zone item.
>> Thus, they don't show at /proc/meminfo. Is this okey?
> Yes. Other large allocations that are done directly via __get_free_pages()
> etc also do not show up there. Slab allocators are intended for small
> allocation and are not effective for large scale allocs. People will
> use multiple different ways of acquiring large memory areas. So there is
> no consistent accounting for that memory.
>
>
>
There's a certain irony here.  In embedded, we get all worked
up about efficiencies in the slab allocators, but don't have a good
way to track the larger memory allocations.  Am I missing
something, or is there really no way to track these large
scale allocations?
  -- Tim


