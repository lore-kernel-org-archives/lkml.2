Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0ISS4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 14:56:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48012 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0ISS4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 14:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hHESdNlhdgJLuIMA4wNqwjNA2qMu7xQZWawwiikZYLhyokPRsEFJjoymucWRTPoVTs
         227SrgX8mMWTOksincacopHoGtwPD07sQdt34INneUl2a9wsk9aScJDb1vp0kTjIbEHi
         n4bbv3rc67mxWVv4QmvPsccuRJUftohu95r48=
MIME-Version: 1.0
In-Reply-To: <4C8E2AE2.9050309@hp.com>
References: <AANLkTinaO5Fqn+QJxxkXSCsW0XWvhBc16jK6HGB_0YG0@mail.gmail.com>
	<4C8E2AE2.9050309@hp.com>
Date: Sun, 19 Sep 2010 14:56:22 -0400
X-Google-Sender-Auth: 3FbPobPAxMYiNAZ-v2HEuTmP_yQ
Message-ID: <AANLkTi=Aj1hNxjCiWaU8=FNWSdu2+0pf3FngjT8aP9p5@mail.gmail.com>
Subject: Re: [PATCHv2 2/5] sctp: implement pluggable multistream scheduling
From: Yaogong Wang <ywang15@ncsu.edu>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
 net/sctp/protocol.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index d40c5cc..0121def 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1310,11 +1310,13 @@ SCTP_STATIC __init int sctp_init(void)
 	/* Add FCFS to sctp_sched_list */
 	status = sctp_register_sched(&sctp_fcfs);
 	if (status)
-		goto err_v6_add_protocol;
+		goto err_register_sched;

 	status = 0;
 out:
 	return status;
+err_register_sched:
+	sctp_v6_del_protocol();
 err_v6_add_protocol:
 	sctp_v4_del_protocol();
 err_add_protocol:
-- 
1.7.0.4



On Mon, Sep 13, 2010 at 9:45 AM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
> One small nit.
>
> On 09/11/2010 09:12 PM, Yaogong Wang wrote:
>> Implement the pluggable multistream scheduling framework.
>> Provide the default first-come-first-serve (FCFS) algorithm.
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
>> index 5027b83..d40c5cc 100644
>> --- a/net/sctp/protocol.c
>> +++ b/net/sctp/protocol.c
>> @@ -1157,6 +1157,9 @@ SCTP_STATIC __init int sctp_init(void)
>>       sctp_max_instreams              = SCTP_DEFAULT_INSTREAMS;
>>       sctp_max_outstreams             = SCTP_DEFAULT_OUTSTREAMS;
>>
>> +     /* Initialize default multistream scheduling algorithm to FCFS */
>> +     sctp_default_sched_ops          = &sctp_fcfs;
>> +
>>       /* Initialize handle used for association ids. */
>>       idr_init(&sctp_assocs_id);
>>
>> @@ -1304,6 +1307,11 @@ SCTP_STATIC __init int sctp_init(void)
>>       if (status)
>>               goto err_v6_add_protocol;
>>
>> +     /* Add FCFS to sctp_sched_list */
>> +     status = sctp_register_sched(&sctp_fcfs);
>> +     if (status)
>> +             goto err_v6_add_protocol;
>> +
>
> This needs its own tag that will call sctp_v6_del_protocol().
>
> -vlad
>
>>       status = 0;
>>  out:
>>       return status;
