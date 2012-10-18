Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2JRXsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:48:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab2JRXsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41386D130@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41386D130@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Thu, 18 Oct 2012 16:47:40 -0700
Message-ID: <CAGTjWtCKwubHVTvqkmSBvU0g6OiDFdKkULu+ZEneLoWyBgQesA@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] efi_pstore: add a sequence counter to a variable name
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 12:02 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> [Problem]
>
> Currently, a variable name, which distinguishes each entry, consists of type, id and ctime.
> But if multiple events happens in a short time, a second/third event may fail to log because
> efi_pstore can't distinguish each event with current variable name.
>
> [Solution]
>
>   A reasonable way to identify all events precisely is introducing a sequence counter to
>   the variable name.
>
> [Patch Description]
>
>   The sequence counter has already supported in a pstore layer with "oopscount".
>   So, this patch adds it to a variable name.
>   Also, it is passed to read/erase callbacks of platform drivers in accordance with
>   the modification of the variable name.
>
>   <before applying this patch>
>  a variable name of first event: dump-type0-1-12345678
>  a variable name of second event: dump-type0-1-12345678
>
>   type:0
>   id:1
>   ctime:12345678
>
>  If multiple events happen in a short time, efi_pstore can't distinguish them because
>  variable names are same among them.
>
>   <after applying this patch>
>
>  it can be distinguishable by adding a sequence counter as follows.
>
>  a variable name of first event: dump-type0-1-1-12345678
>  a variable name of Second event: dump-type0-1-2-12345678
>
>   type:0
>   id:1
>   sequence counter: 1(first event), 2(second event)
>   ctime:12345678

This patch plumbs the count through the same way as you plumbed the
ctime through in patch 1/2, so I'm going to hold off on commenting on
this patch until we better understand i_ctime use is resolved there.
I suspect that we don't want to continue adding more arguments through
pstore ops this way.
