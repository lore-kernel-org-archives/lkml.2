Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410Ab0I0Wvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:51:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53172 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760396Ab0I0Wva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:51:30 -0400
Message-ID: <4CA11FB7.2080101@zytor.com>
Date: Mon, 27 Sep 2010 15:50:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: caiqian@redhat.com, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CA11918.7050708@kernel.org>
In-Reply-To: <4CA11918.7050708@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+		crash_base = alignment;
+		while ((crash_base + crash_size) <= total_mem) {
+			start = memblock_find_in_range(crash_base,
+				crash_base + crash_size, crash_size, alignment);
+
+			if (start == crash_base)
+				break;
+
+			crash_base += alignment;
+		}
+		if (start != crash_base) {

Open-coded crap violation error!

Seriously, these kinds of open-coded loops are *never* acceptable, since
they are really "let's violate the interface by making it do something
it wasn't intended to do" -- it means we need a new interface.

Alternatively, if we really need the lowest possible address, why do we
need to search?

	-hpa
