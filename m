Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2HPO0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:26:15 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:40383 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2HPO0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:26:12 -0400
Message-ID: <20120816172606.26743ozunoe6mbs4@www.81.fi>
Date: Thu, 16 Aug 2012 17:26:06 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Borislav Petkov <bp@alien8.de>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?b?TfxsbGVy?= 
	<tilo.mueller@informatik.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
References: <20120815140331.GB4103@x1.osrc.amd.com>
 <20120815172653.31045.42867.stgit@localhost6.localdomain6>
 <20120816132926.GB12029@x1.osrc.amd.com>
In-Reply-To: <20120816132926.GB12029@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Borislav Petkov <bp@alien8.de>:

> On Wed, Aug 15, 2012 at 08:34:25PM +0300, Jussi Kivilinna wrote:
>> About ~5% slower, probably because I was tuning for sandy-bridge and
>> introduced more FPU<=>CPU register moves.
>>
>> Here's new version of patch, with FPU<=>CPU moves from original
>> implementation.
>>
>> (Note: also changes encryption function to inline all code in to main
>> function, decryption still places common code to separate function to
>> reduce object size. This is to measure the difference.)
>
> Yep, looks better than the previous run and also a bit better or on par
> with the initial run I did.

Thanks again. Speed gained with patch is ~8%, and is able of getting  
twofish-avx pass twofish-3way.

>
> The thing is, I'm not sure whether optimizing the thing for each uarch
> is a workable solution software-wise or maybe having a single version
> which performs sufficiently ok on all uarches is easier/better to
> maintain without causing code bloat. Hmmm...

Agreed, testing on multiple CPUs to get single well working version is  
what I have done in the past. But purchasing all the latest CPUs on  
the market isn't option for me, and for testing AVX I'm stuck with  
sandy-bridge :)

-Jussi

> 4th:
> ====
> ran like 1st.
>
> [ 1014.074150]
> [ 1014.074150] testing speed of async ecb(twofish) encryption
> [ 1014.083829] test 0 (128 bit key, 16 byte blocks): 4870055  
> operations in 1 seconds (77920880 bytes)
> [ 1015.092757] test 1 (128 bit key, 64 byte blocks): 2043828  
> operations in 1 seconds (130804992 bytes)
> [ 1016.099441] test 2 (128 bit key, 256 byte blocks): 606400  
> operations in 1 seconds (155238400 bytes)
> [ 1017.105939] test 3 (128 bit key, 1024 byte blocks): 168939  
> operations in 1 seconds (172993536 bytes)
> [ 1018.112517] test 4 (128 bit key, 8192 byte blocks): 21777  
> operations in 1 seconds (178397184 bytes)
> [ 1019.119035] test 5 (192 bit key, 16 byte blocks): 4882254  
> operations in 1 seconds (78116064 bytes)
> [ 1020.125716] test 6 (192 bit key, 64 byte blocks): 2043230  
> operations in 1 seconds (130766720 bytes)
> [ 1021.132391] test 7 (192 bit key, 256 byte blocks): 607477  
> operations in 1 seconds (155514112 bytes)
> [ 1022.138889] test 8 (192 bit key, 1024 byte blocks): 168743  
> operations in 1 seconds (172792832 bytes)
> [ 1023.145476] test 9 (192 bit key, 8192 byte blocks): 21442  
> operations in 1 seconds (175652864 bytes)
> [ 1024.152012] test 10 (256 bit key, 16 byte blocks): 4891863  
> operations in 1 seconds (78269808 bytes)
> [ 1025.158684] test 11 (256 bit key, 64 byte blocks): 2049390  
> operations in 1 seconds (131160960 bytes)
> [ 1026.165366] test 12 (256 bit key, 256 byte blocks): 606847  
> operations in 1 seconds (155352832 bytes)
> [ 1027.171841] test 13 (256 bit key, 1024 byte blocks): 169228  
> operations in 1 seconds (173289472 bytes)
> [ 1028.178436] test 14 (256 bit key, 8192 byte blocks): 21773  
> operations in 1 seconds (178364416 bytes)
> [ 1029.184981]
> [ 1029.184981] testing speed of async ecb(twofish) decryption
> [ 1029.194508] test 0 (128 bit key, 16 byte blocks): 4931065  
> operations in 1 seconds (78897040 bytes)
> [ 1030.199640] test 1 (128 bit key, 64 byte blocks): 2056931  
> operations in 1 seconds (131643584 bytes)
> [ 1031.206303] test 2 (128 bit key, 256 byte blocks): 589409  
> operations in 1 seconds (150888704 bytes)
> [ 1032.212832] test 3 (128 bit key, 1024 byte blocks): 163681  
> operations in 1 seconds (167609344 bytes)
> [ 1033.219443] test 4 (128 bit key, 8192 byte blocks): 21062  
> operations in 1 seconds (172539904 bytes)
> [ 1034.225979] test 5 (192 bit key, 16 byte blocks): 4931537  
> operations in 1 seconds (78904592 bytes)
> [ 1035.232608] test 6 (192 bit key, 64 byte blocks): 2053989  
> operations in 1 seconds (131455296 bytes)
> [ 1036.239289] test 7 (192 bit key, 256 byte blocks): 589591  
> operations in 1 seconds (150935296 bytes)
> [ 1037.241784] test 8 (192 bit key, 1024 byte blocks): 163565  
> operations in 1 seconds (167490560 bytes)
> [ 1038.244387] test 9 (192 bit key, 8192 byte blocks): 20899  
> operations in 1 seconds (171204608 bytes)
> [ 1039.250923] test 10 (256 bit key, 16 byte blocks): 4937343  
> operations in 1 seconds (78997488 bytes)
> [ 1040.257589] test 11 (256 bit key, 64 byte blocks): 2050678  
> operations in 1 seconds (131243392 bytes)
> [ 1041.264262] test 12 (256 bit key, 256 byte blocks): 586869  
> operations in 1 seconds (150238464 bytes)
> [ 1042.270753] test 13 (256 bit key, 1024 byte blocks): 163548  
> operations in 1 seconds (167473152 bytes)
> [ 1043.277365] test 14 (256 bit key, 8192 byte blocks): 21053  
> operations in 1 seconds (172466176 bytes)
> [ 1044.283892]
> [ 1044.283892] testing speed of async cbc(twofish) encryption
> [ 1044.293349] test 0 (128 bit key, 16 byte blocks): 5186240  
> operations in 1 seconds (82979840 bytes)
> [ 1045.298534] test 1 (128 bit key, 64 byte blocks): 1921034  
> operations in 1 seconds (122946176 bytes)
> [ 1046.305207] test 2 (128 bit key, 256 byte blocks): 542787  
> operations in 1 seconds (138953472 bytes)
> [ 1047.311699] test 3 (128 bit key, 1024 byte blocks): 141399  
> operations in 1 seconds (144792576 bytes)
> [ 1048.318312] test 4 (128 bit key, 8192 byte blocks): 17755  
> operations in 1 seconds (145448960 bytes)
> [ 1049.324829] test 5 (192 bit key, 16 byte blocks): 5196441  
> operations in 1 seconds (83143056 bytes)
> [ 1050.331485] test 6 (192 bit key, 64 byte blocks): 1921456  
> operations in 1 seconds (122973184 bytes)
> [ 1051.338157] test 7 (192 bit key, 256 byte blocks): 543581  
> operations in 1 seconds (139156736 bytes)
> [ 1052.344658] test 8 (192 bit key, 1024 byte blocks): 141473  
> operations in 1 seconds (144868352 bytes)
> [ 1053.351270] test 9 (192 bit key, 8192 byte blocks): 17601  
> operations in 1 seconds (144187392 bytes)
> [ 1054.357823] test 10 (256 bit key, 16 byte blocks): 5190283  
> operations in 1 seconds (83044528 bytes)
> [ 1055.364462] test 11 (256 bit key, 64 byte blocks): 1912796  
> operations in 1 seconds (122418944 bytes)
> [ 1056.371134] test 12 (256 bit key, 256 byte blocks): 542719  
> operations in 1 seconds (138936064 bytes)
> [ 1057.377643] test 13 (256 bit key, 1024 byte blocks): 141377  
> operations in 1 seconds (144770048 bytes)
> [ 1058.384229] test 14 (256 bit key, 8192 byte blocks): 17752  
> operations in 1 seconds (145424384 bytes)
> [ 1059.390799]
> [ 1059.390799] testing speed of async cbc(twofish) decryption
> [ 1059.400187] test 0 (128 bit key, 16 byte blocks): 4889197  
> operations in 1 seconds (78227152 bytes)
> [ 1060.405460] test 1 (128 bit key, 64 byte blocks): 1980831  
> operations in 1 seconds (126773184 bytes)
> [ 1061.408145] test 2 (128 bit key, 256 byte blocks): 568695  
> operations in 1 seconds (145585920 bytes)
> [ 1062.410647] test 3 (128 bit key, 1024 byte blocks): 158294  
> operations in 1 seconds (162093056 bytes)
> [ 1063.417258] test 4 (128 bit key, 8192 byte blocks): 20312  
> operations in 1 seconds (166395904 bytes)
> [ 1064.423758] test 5 (192 bit key, 16 byte blocks): 4904906  
> operations in 1 seconds (78478496 bytes)
> [ 1065.430440] test 6 (192 bit key, 64 byte blocks): 1983636  
> operations in 1 seconds (126952704 bytes)
> [ 1066.437104] test 7 (192 bit key, 256 byte blocks): 564340  
> operations in 1 seconds (144471040 bytes)
> [ 1067.443613] test 8 (192 bit key, 1024 byte blocks): 157404  
> operations in 1 seconds (161181696 bytes)
> [ 1068.450216] test 9 (192 bit key, 8192 byte blocks): 20055  
> operations in 1 seconds (164290560 bytes)
> [ 1069.456753] test 10 (256 bit key, 16 byte blocks): 4901215  
> operations in 1 seconds (78419440 bytes)
> [ 1070.463417] test 11 (256 bit key, 64 byte blocks): 1978968  
> operations in 1 seconds (126653952 bytes)
> [ 1071.470073] test 12 (256 bit key, 256 byte blocks): 568440  
> operations in 1 seconds (145520640 bytes)
> [ 1072.476580] test 13 (256 bit key, 1024 byte blocks): 158329  
> operations in 1 seconds (162128896 bytes)
> [ 1073.483177] test 14 (256 bit key, 8192 byte blocks): 20311  
> operations in 1 seconds (166387712 bytes)
> [ 1074.489739]
> [ 1074.489739] testing speed of async ctr(twofish) encryption
> [ 1074.499266] test 0 (128 bit key, 16 byte blocks): 4565109  
> operations in 1 seconds (73041744 bytes)
> [ 1075.504391] test 1 (128 bit key, 64 byte blocks): 1955085  
> operations in 1 seconds (125125440 bytes)
> [ 1076.511055] test 2 (128 bit key, 256 byte blocks): 573971  
> operations in 1 seconds (146936576 bytes)
> [ 1077.517563] test 3 (128 bit key, 1024 byte blocks): 158489  
> operations in 1 seconds (162292736 bytes)
> [ 1078.524175] test 4 (128 bit key, 8192 byte blocks): 20330  
> operations in 1 seconds (166543360 bytes)
> [ 1079.530702] test 5 (192 bit key, 16 byte blocks): 4550468  
> operations in 1 seconds (72807488 bytes)
> [ 1080.537358] test 6 (192 bit key, 64 byte blocks): 1943897  
> operations in 1 seconds (124409408 bytes)
> [ 1081.544030] test 7 (192 bit key, 256 byte blocks): 564033  
> operations in 1 seconds (144392448 bytes)
> [ 1082.550531] test 8 (192 bit key, 1024 byte blocks): 157126  
> operations in 1 seconds (160897024 bytes)
> [ 1083.557170] test 9 (192 bit key, 8192 byte blocks): 20121  
> operations in 1 seconds (164831232 bytes)
> [ 1084.563713] test 10 (256 bit key, 16 byte blocks): 4403637  
> operations in 1 seconds (70458192 bytes)
> [ 1085.570360] test 11 (256 bit key, 64 byte blocks): 1961264  
> operations in 1 seconds (125520896 bytes)
> [ 1086.577008] test 12 (256 bit key, 256 byte blocks): 571514  
> operations in 1 seconds (146307584 bytes)
> [ 1087.583517] test 13 (256 bit key, 1024 byte blocks): 158342  
> operations in 1 seconds (162142208 bytes)
> [ 1088.590121] test 14 (256 bit key, 8192 byte blocks): 20392  
> operations in 1 seconds (167051264 bytes)
> [ 1089.596648]
> [ 1089.596648] testing speed of async ctr(twofish) decryption
> [ 1089.606061] test 0 (128 bit key, 16 byte blocks): 4517104  
> operations in 1 seconds (72273664 bytes)
> [ 1090.611326] test 1 (128 bit key, 64 byte blocks): 1953102  
> operations in 1 seconds (124998528 bytes)
> [ 1091.617989] test 2 (128 bit key, 256 byte blocks): 574354  
> operations in 1 seconds (147034624 bytes)
> [ 1092.624497] test 3 (128 bit key, 1024 byte blocks): 158402  
> operations in 1 seconds (162203648 bytes)
> [ 1093.631110] test 4 (128 bit key, 8192 byte blocks): 20369  
> operations in 1 seconds (166862848 bytes)
> [ 1094.637618] test 5 (192 bit key, 16 byte blocks): 4524710  
> operations in 1 seconds (72395360 bytes)
> [ 1095.644293] test 6 (192 bit key, 64 byte blocks): 1940148  
> operations in 1 seconds (124169472 bytes)
> [ 1096.650957] test 7 (192 bit key, 256 byte blocks): 567684  
> operations in 1 seconds (145327104 bytes)
> [ 1097.657466] test 8 (192 bit key, 1024 byte blocks): 158922  
> operations in 1 seconds (162736128 bytes)
> [ 1098.664088] test 9 (192 bit key, 8192 byte blocks): 20087  
> operations in 1 seconds (164552704 bytes)
> [ 1099.670596] test 10 (256 bit key, 16 byte blocks): 4397085  
> operations in 1 seconds (70353360 bytes)
> [ 1100.677278] test 11 (256 bit key, 64 byte blocks): 1961007  
> operations in 1 seconds (125504448 bytes)
> [ 1101.683933] test 12 (256 bit key, 256 byte blocks): 577961  
> operations in 1 seconds (147958016 bytes)
> [ 1102.690452] test 13 (256 bit key, 1024 byte blocks): 158836  
> operations in 1 seconds (162648064 bytes)
> [ 1103.697038] test 14 (256 bit key, 8192 byte blocks): 20427  
> operations in 1 seconds (167337984 bytes)
> [ 1104.703575]
> [ 1104.703575] testing speed of async lrw(twofish) encryption
> [ 1104.713108] test 0 (256 bit key, 16 byte blocks): 3555452  
> operations in 1 seconds (56887232 bytes)
> [ 1105.718261] test 1 (256 bit key, 64 byte blocks): 1617632  
> operations in 1 seconds (103528448 bytes)
> [ 1106.724924] test 2 (256 bit key, 256 byte blocks): 495199  
> operations in 1 seconds (126770944 bytes)
> [ 1107.731442] test 3 (256 bit key, 1024 byte blocks): 137358  
> operations in 1 seconds (140654592 bytes)
> [ 1108.738065] test 4 (256 bit key, 8192 byte blocks): 17637  
> operations in 1 seconds (144482304 bytes)
> [ 1109.740593] test 5 (320 bit key, 16 byte blocks): 3478175  
> operations in 1 seconds (55650800 bytes)
> [ 1110.743248] test 6 (320 bit key, 64 byte blocks): 1591957  
> operations in 1 seconds (101885248 bytes)
> [ 1111.749911] test 7 (320 bit key, 256 byte blocks): 493803  
> operations in 1 seconds (126413568 bytes)
> [ 1112.756430] test 8 (320 bit key, 1024 byte blocks): 137066  
> operations in 1 seconds (140355584 bytes)
> [ 1113.763034] test 9 (320 bit key, 8192 byte blocks): 17288  
> operations in 1 seconds (141623296 bytes)
> [ 1114.769587] test 10 (384 bit key, 16 byte blocks): 3576437  
> operations in 1 seconds (57222992 bytes)
> [ 1115.776232] test 11 (384 bit key, 64 byte blocks): 1587771  
> operations in 1 seconds (101617344 bytes)
> [ 1116.782890] test 12 (384 bit key, 256 byte blocks): 493841  
> operations in 1 seconds (126423296 bytes)
> [ 1117.789396] test 13 (384 bit key, 1024 byte blocks): 137324  
> operations in 1 seconds (140619776 bytes)
> [ 1118.795993] test 14 (384 bit key, 8192 byte blocks): 17625  
> operations in 1 seconds (144384000 bytes)
> [ 1119.802548]
> [ 1119.802548] testing speed of async lrw(twofish) decryption
> [ 1119.811940] test 0 (256 bit key, 16 byte blocks): 3590161  
> operations in 1 seconds (57442576 bytes)
> [ 1120.817198] test 1 (256 bit key, 64 byte blocks): 1623745  
> operations in 1 seconds (103919680 bytes)
> [ 1121.823872] test 2 (256 bit key, 256 byte blocks): 482001  
> operations in 1 seconds (123392256 bytes)
> [ 1122.830398] test 3 (256 bit key, 1024 byte blocks): 133842  
> operations in 1 seconds (137054208 bytes)
> [ 1123.836992] test 4 (256 bit key, 8192 byte blocks): 17195  
> operations in 1 seconds (140861440 bytes)
> [ 1124.843536] test 5 (320 bit key, 16 byte blocks): 3536998  
> operations in 1 seconds (56591968 bytes)
> [ 1125.850156] test 6 (320 bit key, 64 byte blocks): 1625698  
> operations in 1 seconds (104044672 bytes)
> [ 1126.856830] test 7 (320 bit key, 256 byte blocks): 482518  
> operations in 1 seconds (123524608 bytes)
> [ 1127.863348] test 8 (320 bit key, 1024 byte blocks): 133672  
> operations in 1 seconds (136880128 bytes)
> [ 1128.869959] test 9 (320 bit key, 8192 byte blocks): 16860  
> operations in 1 seconds (138117120 bytes)
> [ 1129.876469] test 10 (384 bit key, 16 byte blocks): 3637750  
> operations in 1 seconds (58204000 bytes)
> [ 1130.883151] test 11 (384 bit key, 64 byte blocks): 1626131  
> operations in 1 seconds (104072384 bytes)
> [ 1131.889814] test 12 (384 bit key, 256 byte blocks): 483999  
> operations in 1 seconds (123903744 bytes)
> [ 1132.896324] test 13 (384 bit key, 1024 byte blocks): 133598  
> operations in 1 seconds (136804352 bytes)
> [ 1133.902920] test 14 (384 bit key, 8192 byte blocks): 17206  
> operations in 1 seconds (140951552 bytes)
> [ 1134.905485]
> [ 1134.905485] testing speed of async xts(twofish) encryption
> [ 1134.905501] test 0 (256 bit key, 16 byte blocks): 2908165  
> operations in 1 seconds (46530640 bytes)
> [ 1135.908137] test 1 (256 bit key, 64 byte blocks): 1462715  
> operations in 1 seconds (93613760 bytes)
> [ 1136.914715] test 2 (256 bit key, 256 byte blocks): 506478  
> operations in 1 seconds (129658368 bytes)
> [ 1137.921320] test 3 (256 bit key, 1024 byte blocks): 148018  
> operations in 1 seconds (151570432 bytes)
> [ 1138.927924] test 4 (256 bit key, 8192 byte blocks): 19435  
> operations in 1 seconds (159211520 bytes)
> [ 1139.934451] test 5 (384 bit key, 16 byte blocks): 2905195  
> operations in 1 seconds (46483120 bytes)
> [ 1140.941116] test 6 (384 bit key, 64 byte blocks): 1454656  
> operations in 1 seconds (93097984 bytes)
> [ 1141.947683] test 7 (384 bit key, 256 byte blocks): 504479  
> operations in 1 seconds (129146624 bytes)
> [ 1142.954280] test 8 (384 bit key, 1024 byte blocks): 148172  
> operations in 1 seconds (151728128 bytes)
> [ 1143.960892] test 9 (384 bit key, 8192 byte blocks): 19433  
> operations in 1 seconds (159195136 bytes)
> [ 1144.967410] test 10 (512 bit key, 16 byte blocks): 2904583  
> operations in 1 seconds (46473328 bytes)
> [ 1145.974091] test 11 (512 bit key, 64 byte blocks): 1501387  
> operations in 1 seconds (96088768 bytes)
> [ 1146.980652] test 12 (512 bit key, 256 byte blocks): 504501  
> operations in 1 seconds (129152256 bytes)
> [ 1147.987254] test 13 (512 bit key, 1024 byte blocks): 148180  
> operations in 1 seconds (151736320 bytes)
> [ 1148.993842] test 14 (512 bit key, 8192 byte blocks): 19439  
> operations in 1 seconds (159244288 bytes)
> [ 1150.000380]
> [ 1150.000380] testing speed of async xts(twofish) decryption
> [ 1150.009770] test 0 (256 bit key, 16 byte blocks): 3007004  
> operations in 1 seconds (48112064 bytes)
> [ 1151.015056] test 1 (256 bit key, 64 byte blocks): 1534733  
> operations in 1 seconds (98222912 bytes)
> [ 1152.021642] test 2 (256 bit key, 256 byte blocks): 508129  
> operations in 1 seconds (130081024 bytes)
> [ 1153.028246] test 3 (256 bit key, 1024 byte blocks): 144920  
> operations in 1 seconds (148398080 bytes)
> [ 1154.034859] test 4 (256 bit key, 8192 byte blocks): 18870  
> operations in 1 seconds (154583040 bytes)
> [ 1155.041367] test 5 (384 bit key, 16 byte blocks): 3009083  
> operations in 1 seconds (48145328 bytes)
> [ 1156.048040] test 6 (384 bit key, 64 byte blocks): 1535084  
> operations in 1 seconds (98245376 bytes)
> [ 1157.054609] test 7 (384 bit key, 256 byte blocks): 508112  
> operations in 1 seconds (130076672 bytes)
> [ 1158.061215] test 8 (384 bit key, 1024 byte blocks): 145035  
> operations in 1 seconds (148515840 bytes)
> [ 1159.067830] test 9 (384 bit key, 8192 byte blocks): 18890  
> operations in 1 seconds (154746880 bytes)
> [ 1160.070368] test 10 (512 bit key, 16 byte blocks): 3076988  
> operations in 1 seconds (49231808 bytes)
> [ 1161.073040] test 11 (512 bit key, 64 byte blocks): 1540659  
> operations in 1 seconds (98602176 bytes)
> [ 1162.079610] test 12 (512 bit key, 256 byte blocks): 508316  
> operations in 1 seconds (130128896 bytes)
> [ 1163.086195] test 13 (512 bit key, 1024 byte blocks): 144951  
> operations in 1 seconds (148429824 bytes)
> [ 1164.092792] test 14 (512 bit key, 8192 byte blocks): 18865  
> operations in 1 seconds (154542080 bytes)
>
> --
> Regards/Gruss,
> Boris.
>
>



