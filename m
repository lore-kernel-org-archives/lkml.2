Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0IITe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:34:59 -0400
Received: from web32407.mail.mud.yahoo.com ([68.142.207.200]:25901 "HELO
	web32407.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752657Ab0IITe5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:34:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=I46XahIgU7Qw/FjCApU/P2iPVCVsoQ15JvWGyJbTDCWw6EZGxvQStc1P7vMdEnVW7I7I+c6xd4SaGiLwv+5J/3ciJ2KNsPCrbCcdg7fiThVObpwf9wC1bJbh+pd8x7v0VAItRok5hSwZRk49kLYTn9uVdmBzRIZIEtr2mSqiq5Q=;
Message-ID: <198194.69355.qm@web32407.mail.mud.yahoo.com>
X-YMail-OSG: Goylt80VM1mPoL7xVpkT1nxuaqwbEV.kiO9aFPgwwr3Xw1q
 WyNraRMDbdLMCZGLNNC2ZvhTdy2kD1w8EHZbY_tO1Ass86ocg5OABt_cUuTH
 jpEBlMCAnM0bHOL5ytLyCEndUfloUcIL9HOKrjWf.FRnlW2THD2Mvj6SBqFy
 55a1Ms5_BbcyeCY1Ib0OsBydl2F5VK_UglHaKB0sjTyMLrTZ5TB3cXwF9tVS
 PUhb3R8X5xwlOHVy6hOk3fSL800c7DOXHlUTevr.kL6jQK53Vw.lXb1p6e_q
 XIhpc6RDp5pXF6_o9X_aqmdZ2EAv2fw6HSDDxQhFsirzV9gKiyrJCQwE_kqu
 g0REfV0jd
X-Mailer: YahooMailClassic/11.4.7 YahooMailWebService/0.8.105.279950
Date: Thu, 9 Sep 2010 12:34:55 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Subject: Re: scsi_cmnd data_buffer checksum
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <yq1fwxjt5ir.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin,

Thanks. I will go thru the DIF document and code. 

But I had a quick question, isn't that drive has to support "protection enable" also. Also, does Controller FW need to do anything extra to send DIF block down to drive. Ideally we will be sending 512 byte blocks down to drive.

-Anil

--- On Thu, 9/9/10, Martin K. Petersen <martin.petersen@oracle.com> wrote:

> From: Martin K. Petersen <martin.petersen@oracle.com>
> Subject: Re: scsi_cmnd data_buffer checksum
> To: "Anil kumar" <anils_r@yahoo.com>
> Cc: "Christof Schmitt" <christof.schmitt@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Date: Thursday, September 9, 2010, 9:23 AM
> >>>>> "Anil" == Anil
> kumar <anils_r@yahoo.com>
> writes:
> 
> Anil> cmd-> write_buf = (u8
> *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);
> Anil> memcpy(cmd->local_write_buf, cmd->write_buf,
> cmd->scsibufflen(scsi_cmnd));
> 
> You need to walk the scatterlist.  You can't assume
> that the pages are
> contiguous in memory.
> 
> But why are you doing this checksumming stuff manually when
> the existing
> DIX/DIF code can do it for you?
> 
> -- 
> Martin K. Petersen    Oracle Linux
> Engineering
> 


      
