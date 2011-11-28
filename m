Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1K1EGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 23:06:07 -0500
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:54386 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624Ab1K1EGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 23:06:05 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Nov 2011 23:06:04 EST
X-AuditID: 12074424-b7ef76d0000008dc-f0-4ed3077ea121
Message-ID: <4ED3077A.8060206@mit.edu>
Date: Sun, 27 Nov 2011 20:00:58 -0800
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Nuno Santos <nsantos@edigma.com>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org> <4ECF789F.3040001@edigma.com> <4ECF8528.9080800@gmail.com> <4ECFBF56.4000002@edigma.com>
In-Reply-To: <4ECFBF56.4000002@edigma.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42IRYrdT161jv+xnsGW9pcW7E0dZLS7vmsNm
	serabGYHZo+fS9YyeuycdZfd4/MmuQDmKC6blNSczLLUIn27BK6MzfM/sxScZK/4P+srawPj
	b9YuRk4OCQETiafT/zFD2GISF+6tZ+ti5OIQEtjHKPHp3XcWCGcDo8T6DYeYIZxrTBL3+v6D
	tfAKqEl0tTexgdgsAqoSc9f+YAex2QRUJDqWPmACsUUFgiQWbutihKgXlDg58wkLiC0CVDNz
	7WqwOcwCThINO6eC9QoL6Ev8a9kCdcZsRomZx7+BNXMKaEl8abjGCNGgJ7Hj+i9WCFteYvvb
	OcwTGAVnIdkxC0nZLCRlCxiZVzHKpuRW6eYmZuYUpybrFicn5uWlFuma6+VmluilppRuYgSH
	tYvKDsbmQ0qHGAU4GJV4eDdcvuQnxJpYVlyZe4hRkoNJSZTXgeWynxBfUn5KZUZicUZ8UWlO
	avEhRgkOZiUR3p6jQOW8KYmVValF+TApaQ4WJXFem50OfkIC6YklqdmpqQWpRTBZGQ4OJQne
	ZDagoYJFqempFWmZOSUIaSYOTpDhPEDD/UBqeIsLEnOLM9Mh8qcYFaXEeReDJARAEhmleXC9
	sLTzilEc6BVh3gesQFU8wJQF1/0KaDAT0GCOmRdABpckIqSkGhh17Sex9p9irQsxXFcUs2bN
	rylPrgao7v5l6LFvutlkxvqCM/vNwn47z94QbFub3SiypTv98y9RxgvZz2O2mXXv+zZXSatu
	6e7Te2SEWfpXVn1Jzv/+ddUBluiWOycvubx8zDlJtmfPYbMJRZvVxTiTf/5e4vDFkPnNqxn3
	Zvr/PfaxND3g8sVvSizFGYmGWsxFxYkAEHKiwxYDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 08:16 AM, Nuno Santos wrote:
> Hi Jiri,
> 
> Thanks for your reply.
> 
> The algorithm is a matrix transform computation to make a affine a
> geometric transform.
> 
> Basicly it is based on the following functions:
> 
> http://pastebin.com/YHzYuLPU
> 
> Curiously I ran a test before writing this email and guest what.... is
> working!! :)
> 
> But now that I have opened this question here I should ask... is it safe?

[...]

> I'm not protecting the call to the function with kernel_fpu_begin and
> kernel_fpu_end

It's not safe even if you do protect it with kernel_fpu_begin.  On
x86-64, a userspace process that mucks with MXCSR can trivially cause
you to oops even if you use kernel_fpu_begin.  (I'm pretty sure x86-32
has a similar issue, and I imagine that other architectures have related
issues.)  This might change someday, but there are exactly zero use
cases outside staging, so don't hold your breath.

--Andy
