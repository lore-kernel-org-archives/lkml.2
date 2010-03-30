Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab0C3Gka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:40:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47505 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab0C3GkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dnf0zIpBgJ5cpu9D8JGxV/EhBlFOYnCWJmVDCKZRUHkJlf2PHwEoGp4QmOSVm9lDg1
         cOQ+WXbfoz9RBqyIZoNElOD++y15/sJe8xIpFNpBfSejaRFJL2IajzmZwP/SiD274n+S
         NZJmwAmex+d4k+OmdYf1kEVvPiplrUs5kEtO4=
MIME-Version: 1.0
In-Reply-To: <1269930015-863-2-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
	 <1269930015-863-2-git-send-regression-fweisbec@gmail.com>
Date: Tue, 30 Mar 2010 09:40:24 +0300
Message-ID: <b6fcc0a1003292340w3452b4c3wc25282811365c7ef@mail.gmail.com>
Subject: Re: [PATCH 1/6] procfs: Kill BKL in llseek on proc base
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 9:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -728,6 +728,7 @@ out_no_task:
>
>  static const struct file_operations proc_info_file_operations = {
>        .read           = proc_info_read,
> +       .llseek         = generic_file_llseek,

There is no warning for default default_llseek case.
This should be done same way as proc ioctls.
