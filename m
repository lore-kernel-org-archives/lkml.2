Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1HBOTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:19:02 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:45941 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1HBOS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:18:56 -0400
Message-ID: <4E380710.1010204@linux.vnet.ibm.com>
Date: Tue, 02 Aug 2011 11:17:52 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Very strange data loss with jsm driver
References: <20110729160416.GK8562@caffeine.csclub.uwaterloo.ca> <20110729172736.4b199d31@lxorguk.ukuu.org.uk> <20110729165342.GB8566@caffeine.csclub.uwaterloo.ca> <20110729180650.GL8562@caffeine.csclub.uwaterloo.ca> <20110729191442.35d09111@lxorguk.ukuu.org.uk> <20110729181337.GM8562@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20110729181337.GM8562@caffeine.csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11080214-8936-0000-0000-00000405FEC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 03:13 PM, Lennart Sorensen wrote:
>
>  It seems it can't be the tty layer, since other serial drivers seem to
>  work fine. It has to be the jsm.
Well, I finally tested it over here, and what I found is:

If the line has a \r among the first 16 bytes, then the information
is TXed immediately. If there is no \r in the first 16 bytes, then the
information seems to be buffered.

So, it seems that that the patch should ask the driver to TX the
information when we receive a \r or when the buffer is full. Does it
make sense to you ?

Thanks

