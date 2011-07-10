Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1GJGC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 02:02:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48632 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1GJGCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 02:02:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E1908BF.4010700@udo.edu>
References: <4E1908BF.4010700@udo.edu>
Date: Sun, 10 Jul 2011 02:02:54 -0400
Message-ID: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>
Subject: Re: [PATCH] nconfig: prevent segfault on empty menu
From: Arnaud Lacombe <lacombar@gmail.com>
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 9, 2011 at 10:04 PM, Andrej Gelenberg
<andrej.gelenberg@udo.edu> wrote:
> Hello,
>
> i found and fixed an NULL-dereference bug in nconf tool.
>
> How to reproduce:
> 1. $ make nconfig
> 2. disable "Kernel hacking -> Debug Filesystem"
> 3. go to "General setup -> GCOV-based kernel profiling" and hit F2
> it should segfault
>
> Fix: i have added some checks for "struct menu*" to be NULL before it
> get dereferenced
>
I am not a huge fan of this. The frontend should be careful not to try
to request the visibility or the prompt of an invalid menu. Following
this point of view, I would rather see assertion added than a test for
NULL, and fix the frontend appropriately to catch those case. Said
otherwise, there is no reason to apply a fix on the backend for an
nconfig-only issue.

 - Arnaud

> Regards,
> Andrej Gelenberg
>
