Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1DLFqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 01:46:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907Ab1DLFqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 01:46:00 -0400
Date: Mon, 11 Apr 2011 22:48:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: Re: undefined reference to `sparse_keymap_free'
Message-Id: <20110411224819.b349025a.akpm@linux-foundation.org>
In-Reply-To: <BANLkTinNm_j_SpjTXKVPXkWFmyjBZAQWyQ@mail.gmail.com>
References: <BANLkTinNm_j_SpjTXKVPXkWFmyjBZAQWyQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Mon, 11 Apr 2011 23:18:04 -0500 Steve French <smfrench@gmail.com> wrote:

> 2.6.38-rc3 build error:
> 
> drivers/built-in.o: In function `msi_laptop_input_destroy':
> msi-laptop.c:(.text+0x1a3be1): undefined reference to `sparse_keymap_free'
> drivers/built-in.o: In function `msi_send_touchpad_key':
> msi-laptop.c:(.text+0x1a3c45): undefined reference to
> `sparse_keymap_report_event'
> drivers/built-in.o: In function `msi_init':
> msi-laptop.c:(.init.text+0xe055): undefined reference to `sparse_keymap_setup'
> msi-laptop.c:(.init.text+0xe07d): undefined reference to `sparse_keymap_free'
> 

Either a missing CONFIG_INPUT_SPARSEKMAP dependency, or missing stubs in
include/linux/input/sparse-keymap.h?
