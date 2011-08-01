Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1HACGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 22:06:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51458 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1HACGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 22:06:32 -0400
MIME-Version: 1.0
Date: Mon, 1 Aug 2011 10:06:31 +0800
Message-ID: <CAM9Y=f4p6Ch4u88K3eykoL_GjNiitJnD_OSOexKGBuXC58x_tQ@mail.gmail.com>
Subject: Re: Cross Memory Attach v4
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 27, 11:30 am, Christopher Yeoh <cyeoh@au1.ibm.com> wrote:
> Hi Andrew,
>
> Here's an updated version of the Cross Memory Attach patch. Changes
> since the v3:
>
> - Adds x86_64 specific wire up
> - Changes behaviour so process_vm_readv and process_vm_writev return
>   the number of bytes successfully read or written even if an error
>   occurs
> - Adds more kernel doc interface comments
> - rename of some internal functions (process_vm_rw_check_iovecs,
>   process_vm_rw) so they make more sense.
>
> Still need to do benchmarking to see if the optimisation for small
> copies using a local on-stack array in process_vm_rw_core is worth it.
[]

A bit late to the party.

get_user_pages_fast may be a nice win here, since the pages will
almost always be present; it'll backoff to the locked get_user_pages
path to handle the pathological case of swapped pages.

Thanks,
  Daniel
-- 
Daniel J Blueman
