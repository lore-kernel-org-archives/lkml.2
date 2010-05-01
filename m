Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab0EAC4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 22:56:08 -0400
Received: from mail.perches.com ([173.55.12.10]:1816 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab0EACz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 22:55:58 -0400
Subject: Re: [PATCH 01/10] lib: introduce common method to convert hex
 digits
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100430120703.ffab0258.akpm@linux-foundation.org>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
	 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
	 <20100430120703.ffab0258.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Apr 2010 19:55:56 -0700
Message-ID: <1272682556.1648.101.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-30 at 12:07 -0700, Andrew Morton wrote:
> I had to fiddle with it:
> - use tolower(), saving 3 bytes!

tolower could be done after the 0-9 case as well

int hex_to_bin(char ch)
{
	if ((ch >= '0') && (ch <= '9'))
		return ch - '0';
	ch = tolower(ch);
	if ((ch >= 'a') && (ch <= 'f'))
		return ch - 'a' + 10;
	return -1;
}


