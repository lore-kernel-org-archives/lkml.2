Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab0GBEET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 00:04:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60904 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0GBEER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 00:04:17 -0400
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <871vbn2mk9.fsf@linux.vnet.ibm.com> <20100702064108.64034561@notabene.brown>
In-Reply-To: <20100702064108.64034561@notabene.brown>
Mime-Version: 1.0 (iPhone Mail 8A293)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A44260DA-245D-47DD-820E-2F4F1F50BB9D@oracle.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "adilger@sun.com" <adilger@sun.com>, "corbet@lwn.net" <corbet@lwn.net>,
       "serue@us.ibm.com" <serue@us.ibm.com>,
       "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
       "bfields@fieldses.org" <bfields@fieldses.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
       "philippe.deniel@CEA.FR" <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8A293)
From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
Date: Thu, 1 Jul 2010 22:02:29 -0600
To: Neil Brown <neilb@suse.de>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C2D6529.0016:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-01, at 14:41, Neil Brown <neilb@suse.de> wrote:
> I think that it is a little ugly that filesystem uuid extraction is so
> closely tied to filehandle manipulation.  They are certainly related, and we
> certainly need to be able to get the filesystem uuid directly from the
> filesystem, but given that filehandle -> fd mapping doesn't (and shouldn't)
> use the uuid, the fact that fd/name -> filehandle mapping does return the
> uuid looks like it is simply piggy backing some functionality on the side,
> rather than creating a properly designed and general interface.

I disagree. Getting the UUID as part of the filehandle avoids an extra system call for the client and avoids the need for some other non-standard interface to get the UUID.

I'd like to be able to use this interface to implement the distributed open call proposed by the POSIX HECWG. This allows one client to do the path traversal, broadcast the file handle to the (maybe) 1M processes in the job via MPI, and then the other clients can open the file by handle without doing 1M times the full path traversal (which might be 10's of RPCs per process). 

Cheers, Andreas
> 
