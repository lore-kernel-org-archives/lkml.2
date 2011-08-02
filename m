Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1HBOud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:50:33 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:45066 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1HBOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:50:28 -0400
Message-ID: <4E380E77.1040702@linux.vnet.ibm.com>
Date: Tue, 02 Aug 2011 11:49:27 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Very strange data loss with jsm driver
References: <20110729160416.GK8562@caffeine.csclub.uwaterloo.ca> <20110729172736.4b199d31@lxorguk.ukuu.org.uk> <20110729165342.GB8566@caffeine.csclub.uwaterloo.ca> <20110729180650.GL8562@caffeine.csclub.uwaterloo.ca> <20110729191442.35d09111@lxorguk.ukuu.org.uk> <20110729181337.GM8562@caffeine.csclub.uwaterloo.ca> <4E380710.1010204@linux.vnet.ibm.com> <20110802142225.GO8562@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20110802142225.GO8562@caffeine.csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11080214-8936-0000-0000-000004061684
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 11:22 AM, Lennart Sorensen wrote:
>  On Tue, Aug 02, 2011 at 11:17:52AM -0300, Breno Leitao wrote:
> > Well, I finally tested it over here, and what I found is:
> >
> > If the line has a \r among the first 16 bytes, then the information
> > is TXed immediately. If there is no \r in the first 16 bytes, then the
> > information seems to be buffered.
>
>  Where in the driver is this happening?
Well, I just found it doing some test cases.

Enabling the driver debug, I found that ->intr is not being called on
the "incorrect" case.

This is the diff of the logs:

  jsm 0005:02:00.0: finish
  jsm 0005:02:00.0: start
  jsm 0005:02:00.0: finish
-jsm 0005:02:00.0: drivers/tty/serial/jsm/jsm_neo.c:1131 uart_poll: 301
-jsm 0005:02:00.0: drivers/tty/serial/jsm/jsm_neo.c:1161 port: 0 type: 3
-jsm 0005:02:00.0: drivers/tty/serial/jsm/jsm_neo.c:750 isr: 2
-jsm 0005:02:00.0: MOD_STAT: sending to parse_modem_sigs
-jsm 0005:02:00.0: neo_parse_modem: port: 0 msignals: 0
-jsm 0005:02:00.0: Port: 0 DTR: 0 RTS: 0 CTS: 0 DSR: 0 RI: 0 CD: 0
  jsm 0005:02:00.0: start
  jsm 0005:02:00.0: Close. HUPCL set, dropping DTR/RTS
  jsm 0005:02:00.0: finish
-jsm 0005:02:00.0: finish.

Anyway, I am still debugging it.

PS: I will look at the stats regression after I fix this one, ok ?

