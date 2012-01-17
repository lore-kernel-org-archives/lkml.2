Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab2AQEtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 23:49:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64795 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2AQEtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 23:49:49 -0500
Message-ID: <4F14FDE8.6000805@gmail.com>
Date: Mon, 16 Jan 2012 21:49:44 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] KVM: perf: a smart tool to analyse kvm events
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F14AA60.1040904@gmail.com> <4F14DFBC.7050908@linux.vnet.ibm.com>
In-Reply-To: <4F14DFBC.7050908@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------040506040703050002080704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040506040703050002080704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 01/16/2012 07:41 PM, Xiao Guangrong wrote:
>> Have you thought about dumping a time history -- something similar to
>> what perf-script can do with dumping events but adding in kvm-specific
>> analysis like what you are doing in these examples?
>>
> 
> 
> I will look into it and put it to my todo list if it is possible.
> Thanks, David!
> 

I've played around with ways to do it as time (and motivation) allowed.
Attached is one example using perf with the trace-cmd plugin plus a
patch on perf-script to dump time between events:

perf record -e kvm:* -fo /tmp/perf.data -p 2540 -- sleep 1
perf script -i /tmp/perf.data

The output of perf-script is in the attached file. The 5th column is the
dt between successive events which is mainly a convenience.

A perf-kvm-events type command would allow more customization in the
output -- like correlating specific events and computing total time
between exit and entry accounting for HLT reasons -- as well as various
statistical dumps (average, stddev, max/min, histograms).

David


--------------040506040703050002080704
Content-Type: text/plain;
 name="kvm-trace-example.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="kvm-trace-example.txt"

CnFlbXUta3ZtICAyNTQyIFswMDFdIDIwNzU3LjY2MjQyNiAgMC4wMDAwMDEga3ZtX2NyOiBj
cl93cml0ZSAzID0gMHg2ZjMwMDAKcWVtdS1rdm0gIDI1NDIgWzAwMV0gMjA3NTcuNjYyNDMw
ICAwLjAwMDAwNCBrdm1fZW50cnk6IHZjcHUgMApxZW11LWt2bSAgMjU0MiBbMDAxXSAyMDc1
Ny42NjI0MzIgIDAuMDAwMDAyIGt2bV9leGl0OiByZWFzb24gSU9fSU5TVFJVQ1RJT04gcmlw
IDB4ODA2ZDhkYmMgaW5mbyBiMDA4MDAwYiAwCgpxZW11LWt2bSAgMjU0MiBbMDAxXSAyMDc1
Ny42NjI0MzQgIDAuMDAwMDAyIGt2bV9lbXVsYXRlX2luc246IDA6ODA2ZDhkYmM6IGVkCnFl
bXUta3ZtICAyNTQyIFswMDFdIDIwNzU3LjY2MjQzNSAgMC4wMDAwMDEga3ZtX3BpbzogcGlv
X3JlYWQgYXQgMHhiMDA4IHNpemUgNCBjb3VudCAxCnFlbXUta3ZtICAyNTQyIFswMDFdIDIw
NzU3LjY2MjQzNiAgMC4wMDAwMDEga3ZtX3VzZXJzcGFjZV9leGl0OiByZWFzb24gS1ZNX0VY
SVRfSU8gKDIpCnFlbXUta3ZtICAyNTQyIFswMDFdIDIwNzU3LjY2MjQ0MiAgMC4wMDAwMDYg
a3ZtX2VudHJ5OiB2Y3B1IDAKcWVtdS1rdm0gIDI1NDIgWzAwMV0gMjA3NTcuNjYyNDQ0ICAw
LjAwMDAwMiBrdm1fZXhpdDogcmVhc29uIEhMVCByaXAgMHhmNzcwZmQzZCBpbmZvIDAgMAoK
cWVtdS1rdm0gIDI1NDAgWzAwMF0gMjA3NTcuNjY2NDc5ICAwLjAwNDI4NyBrdm1fc2V0X2ly
cTogZ3NpIDkgbGV2ZWwgMSBzb3VyY2UgMApxZW11LWt2bSAgMjU0MCBbMDAwXSAyMDc1Ny42
NjY0ODEgIDAuMDAwMDAyIGt2bV9waWNfc2V0X2lycTogY2hpcCAxIHBpbiAxIChlZGdlfG1h
c2tlZCkKcWVtdS1rdm0gIDI1NDAgWzAwMF0gMjA3NTcuNjY2NDgyICAwLjAwMDAwMSBrdm1f
YXBpY19hY2NlcHRfaXJxOiBhcGljaWQgMCB2ZWMgMTc3IChMb3dQcmlvfGxldmVsKQpxZW11
LWt2bSAgMjU0MCBbMDAwXSAyMDc1Ny42NjY0ODUgIDAuMDAwMDAzIGt2bV9pb2FwaWNfc2V0
X2lycTogcGluIDkgZHN0IDEgdmVjPTE3NyAoTG93UHJpb3xsb2dpY2FsfGxldmVsKQoKcWVt
dS1rdm0gIDI1NDIgWzAwMV0gMjA3NTcuNjY2NTA1ICAwLjAwNDA2MSBrdm1faW5qX3ZpcnE6
IGlycSAxNzcKcWVtdS1rdm0gIDI1NDIgWzAwMV0gMjA3NTcuNjY2NTA2ICAwLjAwMDAwMSBr
dm1fZW50cnk6IHZjcHUgMApxZW11LWt2bSAgMjU0MiBbMDAxXSAyMDc1Ny42NjY1MTIgIDAu
MDAwMDA2IGt2bV9leGl0OiByZWFzb24gSU9fSU5TVFJVQ1RJT04gcmlwIDB4ODA2ZDg4Y2Eg
aW5mbyBiMDAwMDAwOSAwCgpxZW11LWt2bSAgMjU0MiBbMDAxXSAyMDc1Ny42NjY1MTYgIDAu
MDAwMDA0IGt2bV9lbXVsYXRlX2luc246IDA6ODA2ZDg4Y2E6IDY2IGVkCnFlbXUta3ZtICAy
NTQyIFswMDFdIDIwNzU3LjY2NjUxNyAgMC4wMDAwMDEga3ZtX3BpbzogcGlvX3JlYWQgYXQg
MHhiMDAwIHNpemUgMiBjb3VudCAxCnFlbXUta3ZtICAyNTQyIFswMDFdIDIwNzU3LjY2NjUx
OSAgMC4wMDAwMDIga3ZtX3VzZXJzcGFjZV9leGl0OiByZWFzb24gS1ZNX0VYSVRfSU8gKDIp
CnFlbXUta3ZtICAyNTQyIFswMDFdIDIwNzU3LjY2NjUyOCAgMC4wMDAwMDkga3ZtX2VudHJ5
OiB2Y3B1IDAKcWVtdS1rdm0gIDI1NDIgWzAwMV0gMjA3NTcuNjY2NTMxICAwLjAwMDAwMyBr
dm1fZXhpdDogcmVhc29uIElPX0lOU1RSVUNUSU9OIHJpcCAweDgwNmQ4OGJlIGluZm8gYWZl
MDAwMDggMAoKcWVtdS1rdm0gIDI1NDIgWzAwMV0gMjA3NTcuNjY2NTM0ICAwLjAwMDAwMyBr
dm1fZW11bGF0ZV9pbnNuOiAwOjgwNmQ4OGJlOiBlYwpxZW11LWt2bSAgMjU0MiBbMDAxXSAy
MDc1Ny42NjY1MzUgIDAuMDAwMDAxIGt2bV9waW86IHBpb19yZWFkIGF0IDB4YWZlMCBzaXpl
IDEgY291bnQgMQpxZW11LWt2bSAgMjU0MiBbMDAxXSAyMDc1Ny42NjY1MzcgIDAuMDAwMDAy
IGt2bV91c2Vyc3BhY2VfZXhpdDogcmVhc29uIEtWTV9FWElUX0lPICgyKQpxZW11LWt2bSAg
MjU0MiBbMDAxXSAyMDc1Ny42NjY1NDQgIDAuMDAwMDA3IGt2bV9lbnRyeTogdmNwdSAwCnFl
bXUta3ZtICAyNTQyIFswMDFdIDIwNzU3LjY2NjU0NyAgMC4wMDAwMDMga3ZtX2V4aXQ6IHJl
YXNvbiBJT19JTlNUUlVDVElPTiByaXAgMHg4MDZkODhiZSBpbmZvIGFmZTEwMDA4IDAKCnFl
bXUta3ZtICAyNTQyIFswMDFdIDIwNzU3LjY2NjU1MCAgMC4wMDAwMDMga3ZtX2VtdWxhdGVf
aW5zbjogMDo4MDZkODhiZTogZWMKcWVtdS1rdm0gIDI1NDIgWzAwMV0gMjA3NTcuNjY2NTUx
ICAwLjAwMDAwMSBrdm1fcGlvOiBwaW9fcmVhZCBhdCAweGFmZTEgc2l6ZSAxIGNvdW50IDEK
cWVtdS1rdm0gIDI1NDIgWzAwMV0gMjA3NTcuNjY2NTUyICAwLjAwMDAwMSBrdm1fdXNlcnNw
YWNlX2V4aXQ6IHJlYXNvbiBLVk1fRVhJVF9JTyAoMikKcWVtdS1rdm0gIDI1NDIgWzAwMV0g
MjA3NTcuNjY2NTU4ICAwLjAwMDAwNiBrdm1fZW50cnk6IHZjcHUgMApxZW11LWt2bSAgMjU0
MiBbMDAxXSAyMDc1Ny42NjY1NjIgIDAuMDAwMDA0IGt2bV9leGl0OiByZWFzb24gSU9fSU5T
VFJVQ1RJT04gcmlwIDB4ODA2ZDg5MzQgaW5mbyBiMDAwMDAwMSAwCgo=
--------------040506040703050002080704--
