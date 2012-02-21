Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2BUO3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:29:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48640 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab2BUO3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:29:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of xiyou.wangcong@gmail.com designates 10.68.222.194 as permitted sender) smtp.mail=xiyou.wangcong@gmail.com; dkim=pass header.i=xiyou.wangcong@gmail.com
Message-ID: <4F43AA37.5050004@gmail.com>
Date: Tue, 21 Feb 2012 22:29:11 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tao Jiang <jiangtao.jit@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: A problem with percpu variable cpu_number
References: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com> <CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com> <4F411373.50304@gmail.com> <CAOe6JY3yM24CGYOpPc98QfjRYah5U+L9DB46WH60LVrxN9=eRQ@mail.gmail.com> <4F4262A4.9000204@gmail.com> <CAOe6JY1_dYGCK2=+EHARz5mTm=KCgWynnJjA9SuEHfj+Z0xjwA@mail.gmail.com>
In-Reply-To: <CAOe6JY1_dYGCK2=+EHARz5mTm=KCgWynnJjA9SuEHfj+Z0xjwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 08:41 PM, Tao Jiang wrote:
> Hi Cong Wang:
>
> I read the file vmlinux.lds.S in arch/x86/kernel
> section .data..percpu is between .init.data and .init.end
> Is that means these percpu variables will be freed after init?

% grep -e __init_begin -e __init_end -e __per_cpu_start -e __per_cpu_end 
/boot/System.map
0000000000000000 D __per_cpu_start
0000000000014bc0 D __per_cpu_end
ffffffff81cf3000 D __init_begin
ffffffff81dfc000 R __init_end
% objdump -d -j .data..percpu vmlinux | grep cpu_number
000000000000dc38 <cpu_number>:
