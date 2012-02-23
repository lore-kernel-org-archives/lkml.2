Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2BWOkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:40:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39558 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab2BWOkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:40:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.229.136.19 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
MIME-Version: 1.0
In-Reply-To: <1986.1329905936@redhat.com>
References: <1329888587-3087-1-git-send-email-bobbypowers@gmail.com>
	<1986.1329905936@redhat.com>
Date: Thu, 23 Feb 2012 09:40:34 -0500
Message-ID: <CAArOQ2U5CUiZ++RQdaB_AZSWKof4BM1Sbr=GihMRbH-kj_DGAQ@mail.gmail.com>
Subject: Re: [PATCH tip/x86/x32] fs: fix close_on_exec pointer in alloc_fdtable
From: Bobby Powers <bobbypowers@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 5:18 AM, David Howells <dhowells@redhat.com> wrote:
> Bobby Powers <bobbypowers@gmail.com> wrote:
>
>> alloc_fdtable allocates space for the open_fds and close_on_exec
>> bitfields together, as 2 * nr / BITS_PER_BYTE.  close_on_exec needs to
>> point to open_fds + nr / BITS_PER_BYTE, not open_fds + nr /
>> BITS_PER_LONG, as introducted in 1fd36adc: Replace the fd_sets in
>> struct fdtable with an array of unsigned longs.
>>
>> Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
>
> Yes, you're right.  At one point I changed data to be an unsigned long *.
>
> Acked-by: David Howells <dhowells@redhat.com>

Thanks, its nice to have confirmation - I'm still pretty new at this.
Can this get pulled onto tip/x86/x32?  Desktop applications like
firefox and chrome don't work reliably without it.
