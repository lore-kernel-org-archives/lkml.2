Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1F1BO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:14:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40646 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab1F1BNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KtLp3E0H8DWBaqMp02yco3+aRMl16RSLfMr0gz8XzUewVhuh4uIUmthQQTOOQPbBFY
         VpbTu5FU8FFMMnjG2JmIqjmwtrfNfY5IDdPT/Ek9zNoYBj7uMtda+6CzoFezDWwep2Gm
         AktvjQrqGPWfXHBvUu7Z7zr4UYmYaABehAWCk=
MIME-Version: 1.0
In-Reply-To: <1308917318-4749-1-git-send-email-segoon@openwall.com>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
Date: Tue, 28 Jun 2011 06:43:54 +0530
X-Google-Sender-Auth: 7_Iu00vuSryIOOAF9xD5IDUk5KU
Message-ID: <BANLkTine1Q7thbLVUb34ZsRZt4q184dZzg@mail.gmail.com>
Subject: Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 5:38 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> /proc/PID/io may be used for gathering private information.  E.g. for
> openssh and vsftpd daemons wchars/rchars may be used to learn the
> precise password length.  Restrict it to processes being able to ptrace
> the target process.
>

Hmm.. How do I reproduce this, won't they be enough randomness around
rchar/wchar by the time the attacker reads it?

> ptrace_may_access() is needed to prevent keeping open file descriptor of
> "io" file, executing setuid binary and gathering io information of the
> setuid'ed process.

Balbir Singh
