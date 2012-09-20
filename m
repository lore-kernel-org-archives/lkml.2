Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2ITJgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:36:04 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:25499 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2ITJgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:36:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="pdf'?scan'208";a="14650150"
Message-ID: <1348133733.24539.8.camel@oliverchick-Precision-WorkStation-T3400>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
From: Oliver Chick <oliver.chick@citrix.com>
To: Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Sep 2012 10:35:33 +0100
In-Reply-To: <20120919131632.GS8912@reaktio.net>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
	 <20120919131632.GS8912@reaktio.net>
Content-Type: multipart/mixed; boundary="=-WTNocMG3YNTG0rOLTsJV"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-WTNocMG3YNTG0rOLTsJV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

I have attached a graph that shows the results of my benchmarking.

The setup is:
-Xeon X5650
-32GB of Ram
-Xen 4.2
-Linux 3.5.0 for dom0 and domus
-Dom0 has 24 CPUs.
-Each guest has a (separate) xvdb backed by a 1GB ramdisk (/dev/ramX) in
dom0. No LVM on these.
-The setup is that initially 1 guest does an fio sequential read of the
ramdisk, then 2, then 3 etc.
-The y axis is the sum of the iops, as reported by the guests' fio
output.

On Wed, 2012-09-19 at 14:16 +0100, X5650Pasi Kärkkäinen wrote:
> On Wed, Sep 19, 2012 at 11:51:27AM +0100, Oliver Chick wrote:
> > This patch implements persistent grants for the xen-blk{front,back}
> > mechanism. The effect of this change is to reduce the number of unmap
> > operations performed, since they cause a (costly) TLB shootdown. This
> > allows the I/O performance to scale better when a large number of VMs
> > are performing I/O.
> > 
> > Previously, the blkfront driver was supplied a bvec[] from the request
> > queue. This was granted to dom0; dom0 performed the I/O and wrote
> > directly into the grant-mapped memory and unmapped it; blkfront then
> > removed foreign access for that grant. The cost of unmapping scales
> > badly with the number of CPUs in Dom0. An experiment showed that when
> > Dom0 has 24 VCPUs, and guests are performing parallel I/O to a
> > ramdisk, the IPIs from performing unmap's is a bottleneck at 5 guests
> > (at which point 650,000 IOPS are being performed in total). If more
> > than 5 guests are used, the performance declines. By 10 guests, only
> > 400,000 IOPS are being performed.
> > 
> > This patch improves performance by only unmapping when the connection
> > between blkfront and back is broken.
> >
> 
> So how many IOPS can you get with this patch / persistent grants ? 
> 
> -- Pasi
> 


--=-WTNocMG3YNTG0rOLTsJV
Content-Type: application/pdf; name="pers-vs-nonpers.pdf"
Content-Disposition: attachment; filename="pers-vs-nonpers.pdf"
Content-Transfer-Encoding: base64

JVBERi0xLjQKJYHigeOBz4HTXHIKMSAwIG9iago8PAovQ3JlYXRpb25EYXRlIChEOjIwMTIwOTIw
MTAyODI2KQovTW9kRGF0ZSAoRDoyMDEyMDkyMDEwMjgyNikKL1RpdGxlIChSIEdyYXBoaWNzIE91
dHB1dCkKL1Byb2R1Y2VyIChSIDIuMTQuMSkKL0NyZWF0b3IgKFIpCj4+CmVuZG9iagoyIDAgb2Jq
Cjw8IC9UeXBlIC9DYXRhbG9nIC9QYWdlcyAzIDAgUiA+PgplbmRvYmoKNyAwIG9iago8PCAvVHlw
ZSAvUGFnZSAvUGFyZW50IDMgMCBSIC9Db250ZW50cyA4IDAgUiAvUmVzb3VyY2VzIDQgMCBSID4+
CmVuZG9iago4IDAgb2JqCjw8Ci9MZW5ndGggMTE2NCAvRmlsdGVyIC9GbGF0ZURlY29kZQo+Pgpz
dHJlYW0KeJy1V01vHDcMvc+v0NE+WBFJSZy5JmgKGEiA1ov2EOSUuE0Mb+x4HfTv95HSjCeukWQn
aIDY+5akPh4p8pnCeaBwFT4Pv4XPoUwx5aAScw6ZclQOohQLh7vL8Gf4NDw7/P7r8/DiYkgxpRTW
Py9evMa3WsI/w5u3IYX3A4Vz/L8ayBzCq+H5bnj2krDd7i/7cRc05hGeqX3ARtiWSKNq2O3DyfVp
2F3Bursbftl9L3ocI0mgPEaZjo+mlOOIcMUqeUM4gyQJnCbj6vhwGSNzYClR6obwkuOE8MpxpA3h
IL5S4FEibwkH80JBkkYqx4dzKlYdwmMsG9LOYF4Rnr1Yjw8XrxcpGuuWwxccHuGa4rQhcQzmFeE1
W/qPDwfz+CW1xLKh5gXMk4WrJeD4cDA/KsK3JU7E42Rj0QqY5+rhvOHBWlebLFxilQ3hYL5WZ37L
g81gXoofnraEM8eE8FI3dZsM5jUjfIqy4e4ZzGcLz1a7/w3HHPm5MUGZrC7bFNoHmdCeuMPrcPHY
3mGtVghmZ86WnNne4YNdkjf5Zf0GV/b1hsv+D3bjx+/37vDE/Q7vMCVfcqePYzeEM//ZviDROJaQ
dc5fMQYX7r8dzBiQ07QKpnREtCRMWV1HH7O3jJg064PzsneTDqNGTiCtoSxk0Eh7ZEbrmNGDlZN3
lNnc4YNdqNqUne0dPtj7drN9tfv6aqvrnK2uiSrSGjADx/YinyT1m7E0kmXV85ns39Er8CRWyi2p
25bISedD0NenWGu7/ZDxQedHcj3DjDGKtng9E/o1nJ0v/I3/yDOQXk35cTX5F8woANRinWL2I785
2X24O0Xiw8nNl78/3H65P30bduc/+jAyhrGlYVYCr2/CH68OR1CIj7guQ0NyG4gfb26X+P9fH0NF
FNOSIIdRxeqisEOrYs0x2yFTq/IZqhW72e09mRpUW2YfJiSPZmh2NDJCQPFUw95gJVvGG2uSOGkg
M5gDkQvDjpuHWtMn7CTeezu2rdoedrqqaFLOCjzY1WHHzQPnnpBkNeG2DzOmYmu6B9ojxipLjsXP
kV0idrwaASzJJtkyA1zN9XNgPKW2BgTa3q+pacbNA8S1NdiazoLVaHMPJMReJfpMdQ91sdhx88gm
YhiFg0dnHg2DhNx3AVUoblO55LedXDF27B6gFwewbseje3Q8mqj3gYY/TiCtjWUyTo1MHWfcPLRl
LkWxXRaMX/NQTFYmhAauo0/FsYl3x6uxSaNr2WVumryv7aRGTcEaqH9xD+SFdMbugTzgI+FFF5+9
HataetwDeeH2h1byc1Rv8h03j9HUjVHJvkvH1l0bp2xyW3xfdT7UpWTHzSPbS7NzTM5Hx+oXcA/k
pbY1Jl9jcj3ZsXtM7e9RbOaZWzDqVrqQyFHwQrXGbGNJyEVlxyupQcomIRatYRxzWU+u1mh1sqd+
lsUeODrKxQDVgW8yatRfAk6HlHRo4bigTTqu7R10iCLvz+A7Wg7Lo+Qzia33tBL8OaWDi9Z2Pm5D
6eb6/RF6o4fTMlhvL+8OHw/3l5/ul7Y8/AtaU3BbZW5kc3RyZWFtCmVuZG9iagozIDAgb2JqCjw8
IC9UeXBlIC9QYWdlcyAvS2lkcyBbIDcgMCBSIF0gL0NvdW50IDEgL01lZGlhQm94IFswIDAgNTA0
IDUwNF0gPj4KZW5kb2JqCjQgMCBvYmoKPDwKL1Byb2NTZXQgWy9QREYgL1RleHRdCi9Gb250IDw8
IC9GMSAxMCAwIFIgL0YyIDExIDAgUiAvRjMgMTIgMCBSID4+Ci9FeHRHU3RhdGUgPDwgPj4KL0Nv
bG9yU3BhY2UgPDwgL3NSR0IgNSAwIFIgPj4KPj4KZW5kb2JqCjUgMCBvYmoKWy9JQ0NCYXNlZCA2
IDAgUl0KZW5kb2JqCjYgMCBvYmoKPDwgL0FsdGVybmF0ZSAvRGV2aWNlUkdCIC9OIDMgL0xlbmd0
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
YlfGXorTiBPEdcdj46Pjm+KnF/os3LlwPME+oTjh+iLjRXmLLizWWJy++PgSxSWcJUcS0YkxiS2J
7zmhnAbO9NKApbVLp7hs7i7uE54Hbwdvku/KL+dPJLkmlSc9SnZN3p48meKeUpHyVMAWVAuep/qn
1qW+TgtN25/2KT0mvT0Dl5GYcVRIEaYJ+zK1M/Myh7PMs4qzpMucl+1cNiUKEjVlQ9mLsrvFNNnP
1IDERLJeMprjllOT8yY3OvdInnKeMG9gudnyTcsn8n3zv16BWsFd0VugW7C2YHSl58r6VdCqpat6
V+uvLlo9vsZvzYG1hLVpa38otC4sL3y5LmZdT5FW0ZqisfV+61uLFYpFxTc2uGyo24jaKNg4uGnu
pqpNH0t4JRdLrUsrSt9v5m6++JXNV5VffdqStGWwzKFsz1bMVuHW69vctx0oVy7PLx/bHrK9cwdj
R8mOlzuX7LxQYVdRt4uwS7JLWhlc2V1lULW16n11SvVIjVdNe61m7aba17t5u6/s8djTVqdVV1r3
bq9g7816v/rOBqOGin2YfTn7HjZGN/Z/zfq6uUmjqbTpw37hfumBiAN9zY7NzS2aLWWtcKukdfJg
wsHL33h/093GbKtvp7eXHgKHJIcef5v47fXDQYd7j7COtH1n+F1tB7WjpBPqXN451ZXSJe2O6x4+
Gni0t8elp+N7y+/3H9M9VnNc5XjZCcKJohOfTuafnD6Vderp6eTTY71Leu+ciT1zrS+8b/Bs0Nnz
53zPnen37D953vX8sQvOF45eZF3suuRwqXPAfqDjB/sfOgYdBjuHHIe6Lztd7hmeN3ziivuV01e9
r567FnDt0sj8keHrUddv3ki4Ib3Ju/noVvqt57dzbs/cWXMXfbfkntK9ivua9xt+NP2xXeogPT7q
PTrwYMGDO2PcsSc/Zf/0frzoIflhxYTORPMj20fHJn0nLz9e+Hj8SdaTmafFPyv/XPvM5Nl3v3j8
MjAVOzX+XPT806+bX6i/2P/S7mXvdNj0/VcZr2Zel7xRf3PgLett/7uYdxMzue+x7ys/mH7o+Rj0
8e6njE+ffgP3hPP7ZW5kc3RyZWFtCmVuZG9iago5IDAgb2JqCjw8Ci9UeXBlIC9FbmNvZGluZyAv
QmFzZUVuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcKL0RpZmZlcmVuY2VzIFsgNDUvbWludXMgOTYv
cXVvdGVsZWZ0CjE0NC9kb3RsZXNzaSAvZ3JhdmUgL2FjdXRlIC9jaXJjdW1mbGV4IC90aWxkZSAv
bWFjcm9uIC9icmV2ZSAvZG90YWNjZW50Ci9kaWVyZXNpcyAvLm5vdGRlZiAvcmluZyAvY2VkaWxs
YSAvLm5vdGRlZiAvaHVuZ2FydW1sYXV0IC9vZ29uZWsgL2Nhcm9uIC9zcGFjZV0KPj4KZW5kb2Jq
CjEwIDAgb2JqCjw8IC9UeXBlIC9Gb250IC9TdWJ0eXBlIC9UeXBlMSAvTmFtZSAvRjEgL0Jhc2VG
b250IC9aYXBmRGluZ2JhdHMgPj4KZW5kb2JqCjExIDAgb2JqCjw8IC9UeXBlIC9Gb250IC9TdWJ0
eXBlIC9UeXBlMSAvTmFtZSAvRjIgL0Jhc2VGb250IC9IZWx2ZXRpY2EKL0VuY29kaW5nIDkgMCBS
ID4+CmVuZG9iagoxMiAwIG9iago8PCAvVHlwZSAvRm9udCAvU3VidHlwZSAvVHlwZTEgL05hbWUg
L0YzIC9CYXNlRm9udCAvSGVsdmV0aWNhLUJvbGQKL0VuY29kaW5nIDkgMCBSID4+CmVuZG9iagp4
cmVmCjAgMTMKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDIxIDAwMDAwIG4gCjAwMDAwMDAx
NjQgMDAwMDAgbiAKMDAwMDAwMTUyOSAwMDAwMCBuIAowMDAwMDAxNjEyIDAwMDAwIG4gCjAwMDAw
MDE3NDcgMDAwMDAgbiAKMDAwMDAwMTc4MCAwMDAwMCBuIAowMDAwMDAwMjEzIDAwMDAwIG4gCjAw
MDAwMDAyOTMgMDAwMDAgbiAKMDAwMDAwNDQ3NSAwMDAwMCBuIAowMDAwMDA0NzMyIDAwMDAwIG4g
CjAwMDAwMDQ4MTYgMDAwMDAgbiAKMDAwMDAwNDkxMyAwMDAwMCBuIAp0cmFpbGVyCjw8IC9TaXpl
IDEzIC9JbmZvIDEgMCBSIC9Sb290IDIgMCBSID4+CnN0YXJ0eHJlZgo1MDE1CiUlRU9GCg==


--=-WTNocMG3YNTG0rOLTsJV--
