Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0IHLtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 07:49:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5347 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0IHLtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 07:49:14 -0400
Date: Wed, 8 Sep 2010 13:48:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Add support for max6695 and max6696 to lm90 
 driver
Message-ID: <20100908134854.2c60f406@hyperion.delvare>
In-Reply-To: <20100908102816.GA10676@ericsson.com>
References: <1283639675-31714-1-git-send-email-guenter.roeck@ericsson.com>
	<20100906181229.2e25db07@hyperion.delvare>
	<20100908102816.GA10676@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Il1k7BO/3K+pABHB17jJP7Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/Il1k7BO/3K+pABHB17jJP7Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 8 Sep 2010 03:28:16 -0700, Guenter Roeck wrote:
> Hi Jean,
> 
> On Mon, Sep 06, 2010 at 12:12:29PM -0400, Jean Delvare wrote:
> > Hi Guenter,
> > 
> > On Sat, 4 Sep 2010 15:34:35 -0700, Guenter Roeck wrote:
> > > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > > ---
> > > To apply this patch, the previously submitted lm90 cleanup patch has to be
> > > applied first.
> > >
> > > My main concern with this patch is the chip detection code, specifically if it
> > > is able to safely distinguish between MAX6680/81 and MAX6695/96.
> > > Would be great to get some test coverage from a system with one of those chips.
> > 
> > Unfortunately I don't have any of these Maxim chips at hand. I have an
> > ADM1032 but it won't offer much coverage obviously. And I have dumps of
> > Maxim chips, but the real chips behave differently, so it's of little
> > help.
> > 
> Do you by any chance have register dumps of max6657/58/59 ?

Yes I do. I have dumps of max6658 and max6659 chips, I'm attaching
them. Please keep in mind that registers are read sequentially, in
order, and this matters because these chips return the last read value
whenever you access a nonexistent register. This even holds for
registers with fewer than 8 bits, e.g. config1.

> max6659 also supports a 3rd upper limit. Turns out it is convenient to add support
> for this limit first before adding support for max6696. To do that, I'll need
> to be able to distinguish between max6657/58 and max6659. My thought is to check
> for the address and if register 0x16 exists.
> 
> Also, do you happen to remember why address 0x4e for max6659 is not supported by the driver ?
> The code only says that it isn't supported, and it does not detect it, but there
> is not reason. sensors-detect does detect it at address 0x4e.

I think the reason is historical. As we never had a report of anyone
with a MAX6659 chip at 0x4e, and detection for this device is weak, and
the driver didn't support any other device at this address, it seemed
more reasonable to not scan the address at all. Now that the driver
supports more devices at this address and thus scans it anyway, I have
no objection supporting the MAX6659 at 0x4e.

-- 
Jean Delvare

--MP_/Il1k7BO/3K+pABHB17jJP7Z
Content-Type: application/octet-stream; name=max6658.dump
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=max6658.dump

ICAgICAwICAxICAyICAzICA0ICA1ICA2ICA3ICA4ICA5ICBhICBiICBjICBkICBlICBmICAgIDAx
MjM0NTY3ODlhYmNkZWYNCjAwOiAxYSAxZiAwMCAyMCAwNSA0NiBjOSA1MCBjOSBjOSBjOSBjOSBj
OSBjOSBjOSBjOSAgICA/Py4gP0Y/UD8/Pz8/Pz8/DQoxMDogNjAgODAgODAgODAgODAgODAgNTUg
NTUgMDAgNTUgNTUgNTUgNTUgNTUgNTUgNTUgICAgYD8/Pz8/VVUuVVVVVVVVVQ0KMjA6IDU1IDBh
IDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhICAgIFU/Pz8/Pz8/Pz8/
Pz8/Pz8NCjMwOiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAw
YSAgICA/Pz8/Pz8/Pz8/Pz8/Pz8/DQo0MDogMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEg
MGEgMGEgMGEgMGEgMGEgMGEgICAgPz8/Pz8/Pz8/Pz8/Pz8/Pw0KNTA6IDBhIDBhIDBhIDBhIDBh
IDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhICAgID8/Pz8/Pz8/Pz8/Pz8/Pz8NCjYw
OiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/Pz8/
Pz8/Pz8/Pz8/Pz8/DQo3MDogMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEg
MGEgMGEgMGEgICAgPz8/Pz8/Pz8/Pz8/Pz8/Pw0KODA6IDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBh
IDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhICAgID8/Pz8/Pz8/Pz8/Pz8/Pz8NCjkwOiAwYSAwYSAw
YSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/Pz8/Pz8/Pz8/Pz8/
Pz8/DQphMDogMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEg
ICAgPz8/Pz8/Pz8/Pz8/Pz8/Pw0KYjA6IDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBh
IDBhIDBhIDBhIDBhIDBhICAgID8/Pz8/Pz8/Pz8/Pz8/Pz8NCmMwOiAwYSAwYSAwYSAwYSAwYSAw
YSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/Pz8/Pz8/Pz8/Pz8/Pz8/DQpkMDog
MGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgMGEgICAgPz8/Pz8/
Pz8/Pz8/Pz8/Pw0KZTA6IDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBhIDBh
IDBhIDBhICAgID8/Pz8/Pz8/Pz8/Pz8/Pz8NCmYwOiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAw
YSAwYSAwYSAwYSAwYSAwYSA0ZCA0ZCAgICA/Pz8/Pz8/Pz8/Pz8/P01NDQo=

--MP_/Il1k7BO/3K+pABHB17jJP7Z
Content-Type: application/octet-stream; name=max6659.dump
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=max6659.dump

RnJvbTogU3RlZmFuIEFzc21hbm4gPFMuQXNzbWFubkBnbXguZGU+Cgphc3VzOi9zeXMvYnVzL2ky
Yy9kZXZpY2VzLzAtMDA0YyMgaTJjZHVtcCAwIDB4NGMKTm8gc2l6ZSBzcGVjaWZpZWQgKHVzaW5n
IGJ5dGUtZGF0YSBhY2Nlc3MpCldBUk5JTkchIFRoaXMgcHJvZ3JhbSBjYW4gY29uZnVzZSB5b3Vy
IEkyQyBidXMsIGNhdXNlIGRhdGEgbG9zcyBhbmQgd29yc2UhCkkgd2lsbCBwcm9iZSBmaWxlIC9k
ZXYvaTJjLTAsIGFkZHJlc3MgMHg0YywgbW9kZSBieXRlCkNvbnRpbnVlPyBbWS9uXSB5CiAgICAg
MCAgMSAgMiAgMyAgNCAgNSAgNiAgNyAgOCAgOSAgYSAgYiAgYyAgZCAgZSAgZiAgICAwMTIzNDU2
Nzg5YWJjZGVmCjAwOiAzOSAzMiAwMCAwMCAwNCA0NiAwMCAzNyAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAgICA5Mi4uP0YuNy4uLi4uLi4uCjEwOiA4MCAwMCAwMCAwMCAwMCAwMCA1NSA1NSAwMCA2
NCA2NCA2NCA2NCA2NCA2NCA2NCAgICA/Li4uLi5VVS5kZGRkZGRkCjIwOiA2NCAwYSAwYSAwYSAw
YSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICBkPz8/Pz8/Pz8/Pz8/Pz8/CjMw
OiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/Pz8/
Pz8/Pz8/Pz8/Pz8/CjQwOiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAw
YSAwYSAwYSAgICA/Pz8/Pz8/Pz8/Pz8/Pz8/CjUwOiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAw
YSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/Pz8/Pz8/Pz8/Pz8/Pz8/CjYwOiAwYSAwYSAwYSAw
YSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/Pz8/Pz8/Pz8/Pz8/Pz8/
CjcwOiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/
Pz8/Pz8/Pz8/Pz8/Pz8/CjgwOiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAw
YSAwYSAwYSAwYSAgICA/Pz8/Pz8/Pz8/Pz8/Pz8/CjkwOiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAw
YSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/Pz8/Pz8/Pz8/Pz8/Pz8/CmEwOiAwYSAwYSAw
YSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwYSAgICA/Pz8/Pz8/Pz8/Pz8/
Pz8/CmIwOiAwYSAwYSAwYSAwYSAwYSAwYSAwYSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAg
ICA/Pz8/Pz8/Li4uLi4uLi4uCmMwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAgICAuLi4uLi4uLi4uLi4uLi4uCmQwOiAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAgICAuLi4uLi4uLi4uLi4uLi4uCmUwOiAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAgICAuLi4uLi4uLi4u
Li4uLi4uCmYwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCA0ZCA0
ZCAgICAuLi4uLi4uLi4uLi4uLk1NCg==

--MP_/Il1k7BO/3K+pABHB17jJP7Z--
