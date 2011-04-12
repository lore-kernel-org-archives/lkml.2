Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab1DLSFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:05:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61578 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab1DLSFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Dj3FV/bECfsilR+B9UpWhH29ud3eYxwvF4TuNAMlXt/uUoTXpsI5RAI9yxLOMP8UZ9
         l75RgqzE0QnkgVsy3vF3ZNKZlkrdlydAXPXxEG1m1tXXYZZ/j2I4Snj+aYzK1nkSXoWx
         IZgFlqAz85tD1bJ6DpyRasBjgFNR0/DE32OXg=
Message-ID: <4DA4946D.5020403@suse.cz>
Date: Tue, 12 Apr 2011 20:05:33 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Bryan Schumaker <bjschuma@netapp.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, ML netdev <netdev@vger.kernel.org>,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix infinite loop in gss_create_upcall()
References: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org> <4D96E4C5.2080302@suse.cz> <1302122693.16786.0.camel@lade.trondhjem.org> <4D9D5CC9.2040002@suse.cz> <4DA36722.2020402@suse.cz> <4DA36758.4070203@suse.cz> <4DA36DB6.8060108@suse.cz> <4DA48EB0.40600@netapp.com>
In-Reply-To: <4DA48EB0.40600@netapp.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 07:41 PM, Bryan Schumaker wrote:
> On 04/11/2011 05:08 PM, Jiri Slaby wrote:
>>
>> Sorry for an extra message. I've just found out that there appears
>> messages in dmesg:
>> [   58.656048] RPC: AUTH_GSS upcall timed out.
>> [   58.656050] Please check user daemon is running.
>> [   88.656065] RPC: AUTH_GSS upcall timed out.
>> [   88.656068] Please check user daemon is running.
>> [  118.656077] RPC: AUTH_GSS upcall timed out.
>> [  118.656080] Please check user daemon is running.
>> [  148.656049] RPC: AUTH_GSS upcall timed out.
>> [  148.656052] Please check user daemon is running.
>> [  178.656046] RPC: AUTH_GSS upcall timed out.
>> [  178.656049] Please check user daemon is running.
>>
>>
>> I instrumented the code and it's stuck with trying RPC_AUTH_GSS_KRB5.
>>
>> I don't use GSS at all.
>>
>> regards,
> 
> Does this patch help?
> 
> - Bryan
> 
> 
> 
> There can be an infinite loop if gss_create_upcall() is called without
> the userspace program running.  To prevent this, we return -EACCES if
> we notice that pipe_version hasn't changed (indicating that the pipe
> has not been opened).

Yes, it fixes the problem. But it waits 15s before it times out. This is
inacceptable for automounted NFS dirs.

thanks,
-- 
js
suse labs
