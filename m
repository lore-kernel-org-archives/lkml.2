Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944Ab1GMGGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 02:06:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59216 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964809Ab1GMGGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 02:06:30 -0400
MIME-Version: 1.0
In-Reply-To: <1310529537.96670.YahooMailClassic@web29502.mail.ird.yahoo.com>
References: <87mxgku044.fsf@elisp.net>
	<1310529537.96670.YahooMailClassic@web29502.mail.ird.yahoo.com>
Date: Wed, 13 Jul 2011 09:06:29 +0300
X-Google-Sender-Auth: j-hGlwVN9VaCDTp1u6RgY_Gm4ns
Message-ID: <CAOJsxLHi_5yuqvOEoGuGQbz86TTuMpinbHzuNEtmvZaZMhcJYA@mail.gmail.com>
Subject: Re: [PATCH] hfsplus: Add record offset check
From: Pekka Enberg <penberg@kernel.org>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: linux-fsdevel@vger.kernel.org, Naohiro Aota <naota@elisp.net>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@tuxera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 6:58 AM, Hin-Tak Leung <hintak_leung@yahoo.co.uk> wrote:
>> Corrupted disk may return record offset which is larger
>> than node size
>> and cause general protection fault like below:
>
> <snipped>
>
>> This patch add guard for this situation.
>>
>> Signed-off-by: Naohiro Aota <naota@elisp.net>
>
> Nacked. This isn't acceptable. Explained above.

'recoff' is read from disk which can be easily fuzzed to have an
offset that's larger than node_size, no? The kernel shouldn't oops in
that cases so what's the problem with the patch? (The changelog is
terribly vague, though, and needs to be fixed).

                                Pekka
