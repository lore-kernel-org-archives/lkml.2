Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1JTCRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:17:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41498 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab1JTCRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
	<ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
	<CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
Date: Wed, 19 Oct 2011 19:17:18 -0700
Message-ID: <CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
Subject: Re: Latency writing to an mlocked ext4 mapping
From: Andy Lutomirski <luto@amacapital.net>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 6:15 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Oct 19, 2011 at 6:02 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>> What kernel are you using?  A change to keep pages consistent during writeout was landed not too long ago (maybe Linux 3.0) in order to allow checksumming of the data.
>
> 3.0.6, with no relevant patches.  (I have a one-liner added to the tcp
> code that I'll submit sometime soon.)  Would this explain the latency
> in file_update_time or is that a separate issue?  file_update_time
> seems like a good thing to make fully asynchronous (especially if the
> file in question is a fifo, but I've already moved my fifos to tmpfs).

On 2.6.39.4, I got one instance of:

call_rwsem_down_read_failed ext4_map_blocks ext4_da_get_block_prep
__block_write_begin ext4_da_write_begin ext4_page_mkwrite do_wp_page
handle_pte_fault handle_mm_fault do_page_fault page_fault

but I'm not seeing the large numbers of the ext4_page_mkwrite trace
that I get on 3.0.6.  file_update_time is now by far the dominant
cause of latency.

I'll leave it running overnight and see what happens.


--Andy
