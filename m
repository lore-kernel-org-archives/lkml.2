Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2DRUFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:05:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55592 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2DRUE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:04:59 -0400
Date: Wed, 18 Apr 2012 21:07:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
Message-ID: <20120418210727.0d113647@pyramind.ukuu.org.uk>
In-Reply-To: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 5) After running this on my system, the performance was improved quickly.
> 
> 6) I performed the same experiment on our Samsung Smart phones as well. And I have seen a drastic improve in performance after running this for 3/4 times.
>     In case of phones it is more helpful as there is no swap space.
> 
> 7) Your feedback and suggestion is important. Based on the feedback, I can plan to submit the patches officially after performing basic cleanups.

So really I think this tells you two things

1. There are cases where the kernel paging subsystem is perhaps making
poor choices and should have forced out more read only pages.

2. For certain DMA allocation cases it might be a good idea to move the
interface out of the HIBERNATION config option and call it automatically
with the relevant memory allocator when requests for large linear
allocations would otherwise fail.

> This can be even using inside the multimedia drivers that requires large contiguous memory to check if that many memory pages can be reclaimed or not.

Yes - I agree. However the way that the memory is obtained and the use of
shrink_all_memory() should not be exposed as it breaks the abstraction.

If you can use it *within* the contiguous memory allocator so that the
driver does not know about shrink_all_memory, then this would be
interesting and potentially useful.

Alan
