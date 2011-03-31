Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab1CaSyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:54:06 -0400
Received: from mx2.netapp.com ([216.240.18.37]:39358 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759096Ab1CaSyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:54:05 -0400
X-IronPort-AV: E=Sophos;i="4.63,277,1299484800"; 
   d="scan'208";a="536883276"
Message-ID: <4D94CDBC.4010000@netapp.com>
Date: Thu, 31 Mar 2011 14:53:48 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Lightning/1.0b2 Lanikai/3.1.9
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: 2.6.39-rc1 regression: NFS - unable to mount some shares (bisected)
References: <8A85A9B4-D801-476F-B280-CE2B1D04277B@vmware.com> <20110331165035.GA6778@dtor-ws.eng.vmware.com> <4D94B6BD.3010409@netapp.com> <201103311019.52073.dtor@vmware.com>
In-Reply-To: <201103311019.52073.dtor@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

If you apply this patch, does it fix the problem?

Bryan

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index dfd1e6d..9bf41ea 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2204,8 +2204,6 @@ static int nfs4_lookup_root_sec(struct nfs_server *server, struct nfs_fh *fhandl
 		goto out;
 	}
 	ret = nfs4_lookup_root(server, fhandle, info);
-	if (ret < 0)
-		ret = -EAGAIN;
 out:
 	return ret;
 }
@@ -2226,7 +2224,7 @@ static int nfs4_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
 
 	for (i = 0; i < len; i++) {
 		status = nfs4_lookup_root_sec(server, fhandle, info, flav_array[i]);
-		if (status == 0)
+		if (status != -EPERM)
 			break;
 	}
 	if (status == 0)





On 03/31/2011 01:19 PM, Dmitry Torokhov wrote:
> On Thursday, March 31, 2011 10:15:41 am Bryan Schumaker wrote:
>> Thanks for the log and extra info.  What setting does the server use to
>> export /toolchain?  You can usually find this in /etc/exports, but it
>> may be different for NIS.  I would like to set up my NFS server in a
>> similar way so I can try to reproduce what you're seeing.
>>
> 
> Bryan,
> 
> Unfortunately I do not have shell access to the NFS server. I can only 
> provide data that can be collected from the client.
> 
> [dtor@dtor-ws linus]$ showmount --exports build-toolchain
> Export list for build-toolchain:
> /apps      *
> /trees     *
> /toolchain *
> 
> Thanks,
> Dmitry

