Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1FXVrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:47:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64114 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab1FXVri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:47:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=h0v5bn/wDExCpgG/iAhP1xF+i1IlkXY070blengxHmVXw74jH170JvjqAeP5XDXBmZ
         Ie9jKdt7Chh4ZlmP1qUYgnZcNfGdl+jOn4HI6GiiIXFpo9aMRy6oCS6AkJH9B6ZKA4F9
         TIDrQNIKwDlnIP+9JHV1ie3dE0E4hku8Oz3UA=
MIME-Version: 1.0
In-Reply-To: <1301491283-14128-2-git-send-email-samuel.gabrielsson@gmail.com>
References: <1301491283-14128-1-git-send-email-samuel.gabrielsson@gmail.com>
	<1301491283-14128-2-git-send-email-samuel.gabrielsson@gmail.com>
Date: Fri, 24 Jun 2011 14:47:37 -0700
X-Google-Sender-Auth: 5q87eYfT8ov6ZnV9pqwrkiWU9cc
Message-ID: <BANLkTikyp-p8ymJvEmk2+=zsOZ1+JYYGMA@mail.gmail.com>
Subject: Re: [PATCH 2/2] i7core_edac: Add scrubbing support
From: Tony Luck <tony.luck@intel.com>
To: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
Cc: mchehab@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 6:21 AM, Samuel Gabrielsson
<samuel.gabrielsson@gmail.com> wrote:
> +       const u32 cache_line_size = 64;
> +       const u32 freq_dclk = 800*1000000;

Is dclk always 800 MHz?  If so, a #define might me nice - you use it again in
get_sdram_scrub_rate(). If not, then getting the actual frequency from some
place would be good.

> +               dw_scrub = 0x00ffffff & (cache_line_size * freq_dclk / new_bw);

Does this give the right answer? It looks like you overflow the "u32" size
of these calculations when you do 64*800000000 = 51200000000.

> +       return 0xffffffff & (cache_line_size * freq_dclk / (u64) scrubval);

Ditto on the overflow question here.

-Tony
