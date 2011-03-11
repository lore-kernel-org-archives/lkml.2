Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1CKXFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 18:05:10 -0500
Received: from jaguar.mail.utk.edu ([160.36.0.84]:55374 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1CKXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 18:05:08 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Mar 2011 18:05:07 EST
Date: Fri, 11 Mar 2011 17:54:17 -0500 (EST)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: perf: kernel memory leak when inherit enabled
Message-ID: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1883999057-1299884058=:15818"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1883999057-1299884058=:15818
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello

While trying to use perf events with inherit enabled to profile some 
multi-threaded BLAS routines (using PAPI) I ended up out-of-memorying my 
machine.  It turns out you can quickly leak gigabytes of kernel memory
that isn't freed when the process exits.

I've attached a test case that reproduces this.

It leaks on 2.6.37 and 2.6.35.9.  It does not on 2.6.32.

I would like to try on current git and maybe even bisect, but my devel 
machine currently is broken with the ".size expression does not evaluate 
to a constant" binutils nonsense.

Unfortunately I won't have much chance to test any more until Monday, but 
I thought I'd send this in case it's something obvious that can be easily 
reproduced and fixed.

Thanks,

Vince
vweaver1@eecs.utk.edu
--8323329-1883999057-1299884058=:15818
Content-Type: TEXT/x-csrc; name=pe_inherit_memleak.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1103111754170.15818@cl320.eecs.utk.edu>
Content-Description: 
Content-Disposition: attachment; filename=pe_inherit_memleak.c

LyogcGVfaW5oZXJpdF9tZW1sZWFrLmMgICovDQovKiBieSBWaW5jZSBXZWF2
ZXIgICB2d2VhdmVyMSBfYXRfIGVlY3MudXRrLmVkdSAqLw0KDQovKiBFYWNo
IHRpbWUgcnVuIHdpbGwgbGVhayBodW5kcmVkcyBvZiBtZWdhYnl0ZXMgb2Yg
a2VybmVsIG1lbW9yeSAqLw0KDQovKiBDb21waWxlIHdpdGggZ2NjIC1PMiAt
V2FsbCAtbyBwZV9pbmhlcml0X21lbWxlYWsgcGVfaW5oZXJpdF9tZW1sZWFr
LmMgLWxwdGhyZWFkICovDQoNCiNpbmNsdWRlIDxzdGRpby5oPg0KI2luY2x1
ZGUgPHN0ZGxpYi5oPg0KI2luY2x1ZGUgPHN0cmluZy5oPg0KI2luY2x1ZGUg
PHB0aHJlYWQuaD4NCg0KI2luY2x1ZGUgPHVuaXN0ZC5oPg0KI2luY2x1ZGUg
PGFzbS91bmlzdGQuaD4NCiNpbmNsdWRlIDxzeXMvcHJjdGwuaD4NCiNpbmNs
dWRlIDxsaW51eC9wZXJmX2V2ZW50Lmg+DQoNCnZvaWQgKnRocmVhZF93b3Jr
KHZvaWQgKmJsYWgpIHsNCiAgICANCiAgIHJldHVybiBOVUxMOw0KfQ0KDQpp
bnQgcGVyZl9ldmVudF9vcGVuKHN0cnVjdCBwZXJmX2V2ZW50X2F0dHIgKmh3
X2V2ZW50X3VwdHIsDQoJCSAgICBwaWRfdCBwaWQsIGludCBjcHUsIGludCBn
cm91cF9mZCwgdW5zaWduZWQgbG9uZyBmbGFncykgew0KIA0KICAgcmV0dXJu
IHN5c2NhbGwoX19OUl9wZXJmX2V2ZW50X29wZW4sIGh3X2V2ZW50X3VwdHIs
IHBpZCwgY3B1LCBncm91cF9mZCxmbGFncyk7DQp9DQoNCmludCBtYWluKGlu
dCBhcmdjLCBjaGFyKiogYXJndikgew0KICAgDQogICBpbnQgaSxmZDEsZmQy
Ow0KDQogICBzdHJ1Y3QgcGVyZl9ldmVudF9hdHRyIHBlOw0KICAgDQogICBt
ZW1zZXQoJnBlLDAsc2l6ZW9mKHN0cnVjdCBwZXJmX2V2ZW50X2F0dHIpKTsN
Cg0KICAgcGUudHlwZT1QRVJGX1RZUEVfSEFSRFdBUkU7DQogICBwZS5jb25m
aWc9UEVSRl9DT1VOVF9IV19DUFVfQ1lDTEVTOw0KICAgcGUuZGlzYWJsZWQ9
MTsNCiAgIHBlLmluaGVyaXQ9MTsNCiAgIHBlLmV4Y2x1ZGVfa2VybmVsPTE7
DQogICBwZS5leGNsdWRlX2h2PTE7DQogICANCiAgIGZkMT1wZXJmX2V2ZW50
X29wZW4oJnBlLDAsLTEsLTEsMCk7DQogICBpZiAoZmQxPDApIHsNCiAgICAg
IGZwcmludGYoc3RkZXJyLCJFcnJvciBvcGVuaW5nXG4iKTsNCiAgICAgIGV4
aXQoMSk7DQogICB9DQogICANCiAgIHBlLnR5cGU9UEVSRl9UWVBFX0hBUkRX
QVJFOw0KICAgcGUuY29uZmlnPVBFUkZfQ09VTlRfSFdfSU5TVFJVQ1RJT05T
Ow0KICAgcGUuZGlzYWJsZWQ9MDsNCiAgIHBlLmluaGVyaXQ9MTsNCiAgIHBl
LmV4Y2x1ZGVfa2VybmVsPTE7DQogICBwZS5leGNsdWRlX2h2PTE7DQogICAN
CiAgIGZkMj1wZXJmX2V2ZW50X29wZW4oJnBlLDAsLTEsZmQxLDApOw0KICAg
aWYgKGZkMTwwKSB7DQogICAgICBmcHJpbnRmKHN0ZGVyciwiRXJyb3Igb3Bl
bmluZ1xuIik7DQogICAgICBleGl0KDEpOw0KICAgfQ0KICAgICAgIA0KICAg
Zm9yKGk9MDtpPDEwMDAwO2krKykgew0KICAgICAgDQogICAgICBpbnQgajsN
CiAgICAgIHB0aHJlYWRfdCBvdXJfdGhyZWFkWzhdOw0KICAgICAgDQogICAg
ICBmb3Ioaj0wO2o8ODtqKyspIHsNCiAgICAgICAgIHB0aHJlYWRfY3JlYXRl
KCZvdXJfdGhyZWFkW2pdLE5VTEwsdGhyZWFkX3dvcmssMCk7CSANCiAgICAg
IH0NCiAgICAgIA0KICAgICAgZm9yKGo9MDtqPDg7aisrKSB7DQogICAgICAg
ICBwdGhyZWFkX2pvaW4ob3VyX3RocmVhZFtqXSxOVUxMKTsJIA0KICAgICAg
fQ0KICAgICAgDQogICB9DQogICANCiAgIHJldHVybiAwOw0KfQ0K

--8323329-1883999057-1299884058=:15818--
