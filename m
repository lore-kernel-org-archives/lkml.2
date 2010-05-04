Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0EDLeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:34:04 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:50111 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab0EDLeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:34:00 -0400
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.34-rc6 regression: pcmcia no longer compiles
MIME-Version: 1.0
Date: Tue, 04 May 2010 13:33:54 +0200
From: Marc Zyngier <maz@misterjones.org>
Cc: <rpurdie@rpsys.net>, <lenz@cs.wisc.edu>,
       kernel list <linux-kernel@vger.kernel.org>, <arminlitzel@web.de>,
       Cyril Hrubis <metan@ucw.cz>, <thommycheck@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       <dbaryshkov@gmail.com>, <omegamoon@gmail.com>, <eric.y.miao@gmail.com>,
       <utx@penguin.cz>, <zaurus-devel@www.linuxtogo.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pcmcia@lists.infradead.org>,
       <linux@dominikbrodowski.net>
Organization: Metropolis
In-Reply-To: <20100504041448.GA2893@ucw.cz>
References: <20100504041448.GA2893@ucw.cz>
Message-ID: <c79eb84d24e70983f4422c89a35580ff@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Type: multipart/mixed;
	boundary="=_e5a6d83fa019327289c71702b8701836"
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: pavel@ucw.cz, rpurdie@rpsys.net, lenz@cs.wisc.edu, linux-kernel@vger.kernel.org, arminlitzel@web.de, metan@ucw.cz, thommycheck@gmail.com, linux-arm-kernel@lists.infradead.org, dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz, zaurus-devel@lists.linuxtogo.org, rjw@sisk.pl, linux-pcmcia@lists.infradead.org, linux@dominikbrodowski.net
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=_e5a6d83fa019327289c71702b8701836
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 May 2010 06:14:48 +0200, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
> 
> -rc5 compiled ok with similar config.
> 
> Now I get:
> 
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
> make[1]: `include/generated/mach-types.h' is up to date.
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      drivers/pcmcia/pcmcia_ioctl.o
> drivers/pcmcia/pcmcia_ioctl.c: In function 'ds_open':
> drivers/pcmcia/pcmcia_ioctl.c:714: error: 'struct <anonymous>' has no
> member named 'present'
> drivers/pcmcia/pcmcia_ioctl.c: In function 'ds_read':
> drivers/pcmcia/pcmcia_ioctl.c:773: error: 'struct <anonymous>' has no
> member named 'dead'
> drivers/pcmcia/pcmcia_ioctl.c: In function 'ds_ioctl':
> drivers/pcmcia/pcmcia_ioctl.c:841: error: 'struct <anonymous>' has no
> member named 'dead'
> make[2]: *** [drivers/pcmcia/pcmcia_ioctl.o] Error 1
> make[1]: *** [drivers/pcmcia] Error 2
> make: *** [drivers] Error 2

Does the attached patch fix it (compile-tested only)?

        M.
-- 
Who you jivin' with that Cosmik Debris?
--=_e5a6d83fa019327289c71702b8701836
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name*0*="UTF-8''0001-pcmcia-fix-compilation-after-16bit-state-locking-ch"
 name*1*="a.patch";
Content-Disposition: attachment;
 filename*0*="UTF-8''0001-pcmcia-fix-compilation-after-16bit-state-lockin"
 filename*1*="g-cha.patch";

RnJvbSA3ZDI4OWY5YjA2MmUxYjE3ZTk4NWM3ODk4Zjg4MjRlMjQxN2Q3ODNjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJjIFp5bmdpZXIgPG1hekBtaXN0ZXJqb25lcy5vcmc+CkRh
dGU6IFR1ZSwgNCBNYXkgMjAxMCAxMjoyMTo1MyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHBjbWNp
YTogZml4IGNvbXBpbGF0aW9uIGFmdGVyIDE2Yml0IHN0YXRlIGxvY2tpbmcgY2hhbmdlcwoKQ29t
bWl0IDA0ZGUwODE2IChwY21jaWE6IHBjbWNpYV9kZXZfcHJlc2VudCBidWdmaXgpIGJyb2tlIHRo
ZQpkZXByZWNhdGVkIGlvY3RsIGxheWVyLiBGaXggaXQgYnkgZ2V0dGluZyByaWQgb2YgcmVmZXJl
bmNlcyB0bwp1bmV4aXN0aW5nIGZpZWxkcy4KClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8
bWF6QG1pc3RlcmpvbmVzLm9yZz4KUmVwb3J0ZWQtYnk6IFBhdmVsIE1hY2hlayA8cGF2ZWxAdWN3
LmN6PgotLS0KIGRyaXZlcnMvcGNtY2lhL3BjbWNpYV9pb2N0bC5jIHwgICAgNyArLS0tLS0tCiAx
IGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3BjbWNpYS9wY21jaWFfaW9jdGwuYyBiL2RyaXZlcnMvcGNtY2lhL3BjbWNp
YV9pb2N0bC5jCmluZGV4IDEwNGU3M2QuLjc2MzFmYWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNt
Y2lhL3BjbWNpYV9pb2N0bC5jCisrKyBiL2RyaXZlcnMvcGNtY2lhL3BjbWNpYV9pb2N0bC5jCkBA
IC03MTEsNyArNzExLDcgQEAgc3RhdGljIGludCBkc19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUs
IHN0cnVjdCBmaWxlICpmaWxlKQogCSAgICB3YXJuaW5nX3ByaW50ZWQgPSAxOwogICAgIH0KIAot
ICAgIGlmIChzLT5wY21jaWFfc3RhdGUucHJlc2VudCkKKyAgICBpZiAoYXRvbWljX3JlYWQoJnMt
PnByZXNlbnQpKQogCXF1ZXVlX2V2ZW50KHVzZXIsIENTX0VWRU5UX0NBUkRfSU5TRVJUSU9OKTsK
IG91dDoKICAgICB1bmxvY2tfa2VybmVsKCk7CkBAIC03NzAsOSArNzcwLDYgQEAgc3RhdGljIHNz
aXplX3QgZHNfcmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hhciBfX3VzZXIgKmJ1ZiwKIAlyZXR1
cm4gLUVJTzsKIAogICAgIHMgPSB1c2VyLT5zb2NrZXQ7Ci0gICAgaWYgKHMtPnBjbWNpYV9zdGF0
ZS5kZWFkKQotCXJldHVybiAtRUlPOwotCiAgICAgcmV0ID0gd2FpdF9ldmVudF9pbnRlcnJ1cHRp
YmxlKHMtPnF1ZXVlLCAhcXVldWVfZW1wdHkodXNlcikpOwogICAgIGlmIChyZXQgPT0gMCkKIAly
ZXQgPSBwdXRfdXNlcihnZXRfcXVldWVkX2V2ZW50KHVzZXIpLCAoaW50IF9fdXNlciAqKWJ1Zikg
PyAtRUZBVUxUIDogNDsKQEAgLTgzOCw4ICs4MzUsNiBAQCBzdGF0aWMgaW50IGRzX2lvY3RsKHN0
cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlLAogCXJldHVybiAtRUlPOwogCiAg
ICAgcyA9IHVzZXItPnNvY2tldDsKLSAgICBpZiAocy0+cGNtY2lhX3N0YXRlLmRlYWQpCi0JcmV0
dXJuIC1FSU87CiAKICAgICBzaXplID0gKGNtZCAmIElPQ1NJWkVfTUFTSykgPj4gSU9DU0laRV9T
SElGVDsKICAgICBpZiAoc2l6ZSA+IHNpemVvZihkc19pb2N0bF9hcmdfdCkpCi0tIAoxLjcuMC40
Cgo=
--=_e5a6d83fa019327289c71702b8701836--

