Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1LOSko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:40:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58758 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1LOSkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:40:43 -0500
MIME-Version: 1.0
In-Reply-To: <201112151139.32224.ptesarik@suse.cz>
References: <201112140033.58951.ptesarik@suse.cz>
	<CAM_iQpUr3MqwWzeD4Z8KzyErEM4utT=CkpbyecPu75-QDDznHQ@mail.gmail.com>
	<201112151139.32224.ptesarik@suse.cz>
Date: Thu, 15 Dec 2011 10:40:42 -0800
X-Google-Sender-Auth: 6AtDKlStZP8EzlJscRygr6hNAWg
Message-ID: <CAOS58YP8o9xQvZJtpEJobChhJ+pSDQ9PqDwaXFS_h+JFd65jOw@mail.gmail.com>
Subject: Re: Is per_cpu_ptr_to_phys broken?
From: Tejun Heo <tj@kernel.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        surovegin@google.com, gthelen@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Now, per_cpu_ptr() gives the correct virtual address, but
> per_cpu_ptr_to_phys() gets the result wrong, regardless whether it thinks that
> the address is in the first chunk or not:

Yeah, that's me forgetting "+ offset_in_page()" after vmalloc page
translation, which incidentally was also discovered by surovegin last
night. It has been broken forever, by which I mean longer than six
months. I wonder why this is coming up only now. Anyways, please send
me a patch, I'll be push it mainline & to stable.

Thanks.

-- 
tejun
